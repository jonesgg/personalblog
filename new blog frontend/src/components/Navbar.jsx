import { Link, useLocation } from 'react-router-dom'
import './Navbar.css'

function Navbar() {
  const location = useLocation()

  const isActive = (path) => {
    return location.pathname === path ? 'active' : ''
  }

  return (
    <nav className="navbar">
      <div className="navbar-container">
        <Link to="/" className="navbar-brand">
          Grant Rencher
        </Link>
        <div className="navbar-links">
          <Link to="/" className={`navbar-link ${isActive('/')}`}>
            Home
          </Link>
          <Link to="/portfolio" className={`navbar-link ${isActive('/portfolio')}`}>
            Portfolio
          </Link>
          <Link to="/blog" className={`navbar-link ${isActive('/blog')}`}>
            Blog
          </Link>
        </div>
      </div>
    </nav>
  )
}

export default Navbar

