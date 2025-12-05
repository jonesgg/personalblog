import { useState, useEffect } from 'react'
import { useNavigate } from 'react-router-dom'
import './Portfolio.css'
import { API_ENDPOINTS } from '../config/api'

function Portfolio() {
  const [portfolioItems, setPortfolioItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const navigate = useNavigate()

  useEffect(() => {
    const fetchPortfolioItems = async () => {
      try {
        setLoading(true)
        setError(null)
        const response = await fetch(API_ENDPOINTS.PORTFOLIO)
        
        if (!response.ok) {
          throw new Error(`Failed to fetch portfolio items: ${response.statusText}`)
        }

        const data = await response.json()
        
        // Handle Lambda response format (statusCode, headers, body)
        let portfolioData = data
        if (data.statusCode && data.body) {
          // If body is a string, parse it
          portfolioData = typeof data.body === 'string' ? JSON.parse(data.body) : data.body
        }

        if (portfolioData.portfolio && Array.isArray(portfolioData.portfolio)) {
          setPortfolioItems(portfolioData.portfolio)
        } else {
          setPortfolioItems([])
        }
      } catch (err) {
        console.error('Error fetching portfolio items:', err)
        setError(err.message)
        setPortfolioItems([])
      } finally {
        setLoading(false)
      }
    }

    fetchPortfolioItems()
  }, [])

  const handleItemClick = (slug) => {
    navigate(`/portfolio/${slug}`)
  }

  return (
    <div className="page portfolio">
      <div className="page-content">
        <h1 className="page-title">Portfolio</h1>
        {loading && <p>Loading portfolio items...</p>}
        {error && <p style={{ color: 'red' }}>Error: {error}</p>}
        {!loading && !error && portfolioItems.length === 0 && (
          <p>No portfolio items found.</p>
        )}
        {!loading && !error && portfolioItems.length > 0 && (
          <div className="portfolio-grid">
            {portfolioItems.map((item) => (
              <div 
                key={item.id} 
                className="portfolio-item"
                onClick={() => handleItemClick(item.slug)}
                style={{ cursor: 'pointer' }}
              >
                <div className="portfolio-item-content">
                  <h3>{item.title}</h3>
                  {item.summary && <p>{item.summary}</p>}
                </div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

export default Portfolio

