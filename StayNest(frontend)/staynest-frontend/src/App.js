import React, { useState, useEffect } from "react";
import "./App.css";

function App() {
  const [hotels, setHotels] = useState([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState("");

  const [currentView, setCurrentView] = useState("home"); 
  const [selectedHotel, setSelectedHotel] = useState(null);
  const [checkInDate, setCheckInDate] = useState("");
  const [checkOutDate, setCheckOutDate] = useState("");
  const [myBookings, setMyBookings] = useState([]); 
  const [adminBookings, setAdminBookings] = useState([]);
  const [availableRooms, setAvailableRooms] = useState([]);
  const [selectedRoomId, setSelectedRoomId] = useState("");
  const [numRooms, setNumRooms] = useState(1);

  const [currentUser, setCurrentUser] = useState(null);
  const [showAuthModal, setShowAuthModal] = useState(false);
  const [isLoginMode, setIsLoginMode] = useState(true);

  const [authEmail, setAuthEmail] = useState("");
  const [authPassword, setAuthPassword] = useState("");
  const [showPassword, setShowPassword] = useState(false); 
  const [authFullName, setAuthFullName] = useState("");
  const [authPhone, setAuthPhone] = useState("");

  // 🌟 NEW: Array pointing to your local public/images folder!
  const hotelImages = [
    "/images/hotel1.jpg",
    "/images/hotel2.jpg",
    "/images/hotel3.jpg",
    "/images/hotel4.jpg",
    "/images/hotel5.jpg"
  ];

  useEffect(() => {
    fetch("http://localhost:8080/StayNest/api/hotels")
      .then((response) => response.json())
      .then((data) => {
        setHotels(data);
        setLoading(false);
      })
      .catch((error) => {
        console.error("Error fetching data:", error);
        setLoading(false);
      });
  }, []);

  useEffect(() => {
    if (selectedHotel) {
      fetch(`http://localhost:8080/StayNest/api/rooms?hotelId=${selectedHotel.hotelId}`)
        .then((response) => response.json())
        .then((data) => {
          setAvailableRooms(data);
          if (data.length > 0) setSelectedRoomId(data[0].roomId);
        })
        .catch((error) => console.error("Error fetching rooms:", error));
    }
  }, [selectedHotel]);

  const loadMyBookings = () => {
    if (!currentUser) return;
    fetch(`http://localhost:8080/StayNest/api/bookings?userId=${currentUser.userId}`)
      .then((response) => response.json())
      .then((data) => setMyBookings(data))
      .catch((error) => console.error("Error fetching bookings:", error));
  };

  const loadAdminBookings = () => {
    fetch("http://localhost:8080/StayNest/api/bookings?admin=true")
      .then((response) => response.json())
      .then((data) => setAdminBookings(data))
      .catch((error) => console.error("Error fetching admin bookings:", error));
  };

  const handleAdminDelete = (bookingId) => {
    if (window.confirm("⚠️ WARNING: This will permanently delete this booking from the database. Continue?")) {
      fetch(`http://localhost:8080/StayNest/api/bookings?bookingId=${bookingId}&action=hard_delete`, {
          method: "DELETE",
        })
        .then((response) => response.json())
        .then((data) => {
          if (data.status === "success") {
            alert("✅ " + data.message);
            loadAdminBookings(); 
          }
        });
    }
  };

  useEffect(() => {
    if (currentView === "bookings") loadMyBookings();
    if (currentView === "admin") loadAdminBookings();
  }, [currentView, currentUser]);

  const handleAuthSubmit = (e) => {
    e.preventDefault();
    const action = isLoginMode ? "login" : "register";
    const payload = {
      action: action,
      email: authEmail,
      password: authPassword,
      fullName: authFullName,
      phoneNumber: authPhone,
    };

    fetch("http://localhost:8080/StayNest/api/auth", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(payload),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          alert("🎉 " + data.message);
          if (isLoginMode) {
            setCurrentUser(data.user);
            setShowAuthModal(false);
          } else {
            setIsLoginMode(true);
            setAuthPassword("");
          }
        } else {
          alert("❌ Error: " + data.message);
        }
      })
      .catch((error) => console.error("Auth error:", error));
  };

  const handleBooking = () => {
    if (!currentUser) {
      alert("Please log in to book a stay!");
      setShowAuthModal(true);
      return;
    }
    const chosenRoom = availableRooms.find((r) => r.roomId === parseInt(selectedRoomId));
    if (!chosenRoom) {
      alert("Please select a room type.");
      return;
    }
    if (!checkInDate || !checkOutDate) {
      alert("Please select both check-in and check-out dates!");
      return;
    }

    const start = new Date(checkInDate);
    const end = new Date(checkOutDate);
    const timeDifference = end.getTime() - start.getTime();
    const numberOfNights = Math.ceil(timeDifference / (1000 * 3600 * 24));

    if (numberOfNights <= 0) {
      alert("Check-out date must be after your check-in date!");
      return;
    }

    const calculatedTotal = numberOfNights * chosenRoom.pricePerNight * numRooms;
    const bookingData = {
      userId: currentUser.userId,
      hotelId: selectedHotel.hotelId,
      roomId: chosenRoom.roomId,
      numberOfRooms: numRooms, 
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      totalPrice: calculatedTotal,
    };

    fetch("http://localhost:8080/StayNest/api/bookings", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(bookingData),
    })
      .then((response) => response.json())
      .then((data) => {
        if (data.status === "success") {
          alert(`🎉 Booking saved! Total cost for ${numberOfNights} nights: ₹${calculatedTotal}`);
          setSelectedHotel(null);
          setCheckInDate("");
          setCheckOutDate("");
          setAvailableRooms([]); 
          setCurrentView("bookings"); 
        } else {
          alert("❌ Error: " + data.message);
        }
      })
      .catch((error) => console.error("Error saving booking:", error));
  };

  const handleCancelBooking = (bookingId) => {
    if (window.confirm("Are you sure you want to cancel this booking?")) {
      fetch(`http://localhost:8080/StayNest/api/bookings?bookingId=${bookingId}`, {
          method: "DELETE",
        })
        .then((response) => response.json())
        .then((data) => {
          if (data.status === "success") {
            alert("✅ " + data.message);
            loadMyBookings(); 
          } else {
            alert("❌ Error: " + data.message);
          }
        })
        .catch((error) => console.error("Error canceling booking:", error));
    }
  };

  const filteredHotels = hotels.filter(
    (hotel) =>
      hotel.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      hotel.location.toLowerCase().includes(searchTerm.toLowerCase()),
  );

  const getHotelName = (roomId) => {
    const hotel = hotels.find((h) => h.hotelId === roomId);
    return hotel ? hotel.name : "Unknown Hotel";
  };

  return (
    <div className="App">
      <header className="header">
        <div className="top-bar">
          {currentUser ? (
            <div className="user-greeting">
              Welcome, <strong>{currentUser.fullName}</strong>!
              <button className="nav-btn" onClick={() => setCurrentView("home")}>Home</button>
              <button className="nav-btn" onClick={() => setCurrentView("bookings")}>My Trips</button>
              {currentUser.email === "debojyotibanerjee45@gmail.com" && (
                <button
                  className="nav-btn"
                  onClick={() => setCurrentView("admin")}
                  style={{ backgroundColor: "#e67e22", color: "white" }}
                >
                  Admin Panel
                </button>
              )}
              <button
                className="logout-btn"
                onClick={() => { setCurrentUser(null); setCurrentView("home"); }}
              >
                Log Out
              </button>
            </div>
          ) : (
            <button className="login-btn" onClick={() => setShowAuthModal(true)}>
              Sign In / Register
            </button>
          )}
        </div>

        <h1>StayNest 🌴</h1>
        <p>Discover beautiful stays across West Bengal</p>

        {currentView === "home" && (
          <div className="search-container">
            <input
              type="text"
              placeholder="Search by city or hotel..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="search-input"
            />
          </div>
        )}
      </header>

      {/* VIEW 1: HOME (Hotel Grid) */}
      {currentView === "home" && (
        <>
          {loading ? (
            <p className="loading">Loading hotels from database...</p>
          ) : (
            <div className="hotel-grid">
              {filteredHotels.length > 0 ? (
                // 🌟 FIX: Map includes 'index' for image selection
                filteredHotels.map((hotel, index) => (
                  <div key={hotel.hotelId} className="hotel-card">
                    
                    {/* 🌟 NEW: Edge-to-edge image wrapper */}
                    <div className="card-image-wrapper">
                      <img 
                        src={hotelImages[index % hotelImages.length]} 
                        alt={hotel.name} 
                        className="card-image"
                        onError={(e) => {
                          e.target.onerror = null;
                          // Custom fallback for the dark theme!
                          e.target.src = "https://placehold.co/800x500/0b1021/00f2fe?text=StayNest+Property";
                        }}
                      />
                    </div>
                    
                    {/* 🌟 NEW: Content wrapper so padding doesn't affect the image */}
                    <div className="card-content">
                      <h2>{hotel.name}</h2>
                      <p className="location">📍 {hotel.location}</p>
                      <p className="description">{hotel.description}</p>
                      <div className="price-tag">
                        Starts at <strong>₹{hotel.startingPrice}</strong> / night
                      </div>
                      <p className="amenities">
                        ✨ <strong>Amenities:</strong> {hotel.amenities}
                      </p>
                      <button className="book-btn" onClick={() => setSelectedHotel(hotel)}>
                        Book Now
                      </button>
                    </div>

                  </div>
                ))
              ) : (
                <p className="no-results">
                  No hotels found matching "{searchTerm}"
                </p>
              )}
            </div>
          )}
        </>
      )}

      {/* VIEW 2: MY BOOKINGS DASHBOARD */}
      {currentView === "bookings" && (
        <div className="dashboard-container">
          <h2>Your Upcoming Trips</h2>
          {myBookings.length === 0 ? (
            <p>You have no bookings yet. Go find a great place to stay!</p>
          ) : (
            <div className="booking-list">
              {myBookings.map((booking) => (
                <div key={booking.bookingId} className={`booking-card ${booking.status.toLowerCase()}`}>
                  <h3>{getHotelName(booking.hotelId)}</h3>
                  <p><strong>Rooms Booked:</strong> {booking.numberOfRooms}</p>
                  <p><strong>Check-in:</strong> {booking.checkInDate}</p>
                  <p><strong>Check-out:</strong> {booking.checkOutDate}</p>
                  <p><strong>Total Payable Amount:</strong> ₹{booking.totalPrice}</p>

                  <div className="booking-status">
                    Status:{" "}
                    <span className={`status-badge ${booking.status.toLowerCase()}`}>
                      {booking.status}
                    </span>
                  </div>

                  {booking.status !== "CANCELLED" && (
                    <button className="cancel-booking-btn" onClick={() => handleCancelBooking(booking.bookingId)}>
                      Cancel Reservation
                    </button>
                  )}
                </div>
              ))}
            </div>
          )}
        </div>
      )}

      {/* VIEW 3: ADMIN DASHBOARD */}
      {currentView === "admin" && (
        <div className="dashboard-container" style={{ maxWidth: "1000px" }}>
          <h2>⚙️ Admin Control Center</h2>
          <p>God-view of all system bookings.</p>

          <table style={{ width: "100%", textAlign: "left", borderCollapse: "collapse", marginTop: "20px", background: "white" }}>
            <thead>
              <tr style={{ backgroundColor: "#2c3e50", color: "white" }}>
                <th style={{ padding: "12px" }}>ID</th>
                <th style={{ padding: "12px" }}>User ID</th>
                <th style={{ padding: "12px" }}>Hotel</th>
                <th style={{ padding: "12px" }}>Rooms</th>
                <th style={{ padding: "12px" }}>Check-in</th>
                <th style={{ padding: "12px" }}>Check-out</th>
                <th style={{ padding: "12px" }}>Total Payable</th>
                <th style={{ padding: "12px" }}>Status</th>
                <th style={{ padding: "12px" }}>Admin Actions</th>
              </tr>
            </thead>
            <tbody>
              {adminBookings.map((booking) => (
                <tr key={booking.bookingId} style={{ borderBottom: "1px solid #ddd" }}>
                  <td style={{ padding: "12px" }}>{booking.bookingId}</td>
                  <td style={{ padding: "12px" }}>User {booking.userId}</td>
                  <td style={{ padding: "12px" }}>{getHotelName(booking.hotelId)}</td>
                  <td style={{ padding: "12px" }}>{booking.numberOfRooms}</td>
                  <td style={{ padding: "12px" }}>{booking.checkInDate}</td>
                  <td style={{ padding: "12px" }}>{booking.checkOutDate}</td>
                  <td style={{ padding: "12px" }}>₹{booking.totalPrice}</td>
                  <td style={{ padding: "12px" }}>
                    <span className={`status-badge ${booking.status.toLowerCase()}`}>
                      {booking.status}
                    </span>
                  </td>
                  <td style={{ padding: "12px" }}>
                    <button
                      onClick={() => handleAdminDelete(booking.bookingId)}
                      style={{ background: "#e74c3c", color: "white", border: "none", padding: "5px 10px", borderRadius: "3px", cursor: "pointer" }}
                    >
                      Delete
                    </button>
                  </td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}

      {/* Auth Modal */}
      {showAuthModal && (
        <div className="modal-overlay">
          <div className="modal auth-modal">
            <h2>{isLoginMode ? "Sign In" : "Create an Account"}</h2>
            <form onSubmit={handleAuthSubmit} className="auth-form">
              {!isLoginMode && (
                <>
                  <input type="text" placeholder="Full Name" required value={authFullName} onChange={(e) => setAuthFullName(e.target.value)} />
                  <input type="tel" placeholder="Phone Number" required value={authPhone} onChange={(e) => setAuthPhone(e.target.value)} />
                </>
              )}
              <input type="email" placeholder="Email Address" required value={authEmail} onChange={(e) => setAuthEmail(e.target.value)} />
              
              <div className="password-wrapper">
                <input type={showPassword ? "text" : "password"} placeholder="Password" required value={authPassword} onChange={(e) => setAuthPassword(e.target.value)} />
                <button type="button" className="eye-btn" onClick={() => setShowPassword(!showPassword)}>
                  {showPassword ? "👁️‍🗨️" : "👁️"}
                </button>
              </div>

              <button type="submit" className="confirm-btn">
                {isLoginMode ? "Log In" : "Sign Up"}
              </button>
            </form>
            <p className="toggle-auth">
              <span onClick={() => setIsLoginMode(!isLoginMode)}>
                {isLoginMode ? "Sign up here." : "Log in here."}
              </span>
            </p>
            <button className="cancel-btn close-auth" onClick={() => setShowAuthModal(false)}>
              Close
            </button>
          </div>
        </div>
      )}

      {/* Booking Modal */}
      {selectedHotel && (
        <div className="modal-overlay">
          <div className="modal">
            <h2>Book your stay at {selectedHotel.name}</h2>

            <div className="room-select-group">
              <label className="room-select-label">Select Room Type</label>
              <select className="room-select" value={selectedRoomId} onChange={(e) => setSelectedRoomId(e.target.value)}>
                {availableRooms.length === 0 ? (
                  <option value="">Loading available rooms...</option>
                ) : (
                  availableRooms.map((room) => (
                    <option key={room.roomId} value={room.roomId}>
                      {room.roomType} - ₹{room.pricePerNight} / night
                    </option>
                  ))
                )}
              </select>
            </div>

            <div className="room-select-group">
              <label className="room-select-label">
                Number of Rooms
                <span className="room-hint-text">(max 2 couples and one child per room)</span>
              </label>
              <select className="room-select" value={numRooms} onChange={(e) => setNumRooms(parseInt(e.target.value))}>
                {[1, 2, 3, 4, 5].map((num) => (
                  <option key={num} value={num}>
                    {num} Room{num > 1 ? "s" : ""}
                  </option>
                ))}
              </select>
            </div>

            <div className="date-picker-group">
              <div>
                <label style={{color: "#00f2fe", fontWeight: "bold", display: "block", marginBottom: "8px"}}>Check-in</label>
                <input type="date" className="date-input" value={checkInDate} onChange={(e) => setCheckInDate(e.target.value)} />
              </div>
              <div>
                <label style={{color: "#00f2fe", fontWeight: "bold", display: "block", marginBottom: "8px"}}>Check-out</label>
                <input type="date" className="date-input" value={checkOutDate} onChange={(e) => setCheckOutDate(e.target.value)} />
              </div>
            </div>

            <div className="modal-actions">
              <button className="confirm-btn" onClick={handleBooking}>Confirm Booking</button>
              <button className="cancel-btn" onClick={() => {
                setSelectedHotel(null);
                setCheckInDate("");
                setCheckOutDate("");
                setAvailableRooms([]);
                setNumRooms(1);
              }}>Cancel</button>
            </div>
          </div>
        </div>
      )}
      
      <footer className="footer">
        <p>Developed by: <strong>Debojyoti Banerjee</strong></p>
        <p>
          Contact Developer:{" "}
          <a href="https://linktr.ee/Debojyoti_Banerjee" target="_blank" rel="noopener noreferrer">
            https://linktr.ee/Debojyoti_Banerjee
          </a>
        </p>
      </footer>
    </div>
  );
}

export default App;