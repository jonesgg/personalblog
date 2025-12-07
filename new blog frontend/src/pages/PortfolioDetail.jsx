import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import './PortfolioDetail.css'
import { API_ENDPOINTS } from '../config/api'

function PortfolioDetail() {
  const { slug } = useParams()
  const navigate = useNavigate()
  const [portfolioItem, setPortfolioItem] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    const fetchPortfolioItem = async () => {
      if (!slug) return

      try {
        setLoading(true)
        setError(null)
        const response = await fetch(`${API_ENDPOINTS.PORTFOLIO}/${slug}`)
        
        if (!response.ok) {
          if (response.status === 404) {
            throw new Error('Portfolio item not found')
          }
          throw new Error(`Failed to fetch portfolio item: ${response.statusText}`)
        }

        const data = await response.json()
        
        // Handle Lambda response format (statusCode, headers, body)
        let portfolioData = data
        if (data.statusCode && data.body) {
          // If body is a string, parse it
          portfolioData = typeof data.body === 'string' ? JSON.parse(data.body) : data.body
        }

        setPortfolioItem(portfolioData)
      } catch (err) {
        console.error('Error fetching portfolio item:', err)
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchPortfolioItem()
  }, [slug])

  const renderContent = () => {
    if (!portfolioItem || !portfolioItem.content || !Array.isArray(portfolioItem.content)) {
      return null
    }

    return portfolioItem.content.map((item, index) => {
      // Each item is an object with exactly one field: title, paragraph, or image_url
      if (item.title) {
        return <h2 key={index} className="content-title">{item.title}</h2>
      } else if (item.paragraph) {
        return <p key={index} className="content-paragraph">{item.paragraph}</p>
      } else if (item.image_url) {
        return (
          <img 
            key={index} 
            src={item.image_url} 
            alt="Portfolio content" 
            className="content-image"
          />
        )
      }
      return null
    })
  }

  if (loading) {
    return (
      <div className="page portfolio-detail">
        <div className="page-content">
          <p>Loading portfolio item...</p>
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="page portfolio-detail">
        <div className="page-content">
          <p style={{ color: 'red' }}>Error: {error}</p>
          <button onClick={() => navigate('/portfolio')} className="back-button">
            Back to Portfolio
          </button>
        </div>
      </div>
    )
  }

  if (!portfolioItem) {
    return (
      <div className="page portfolio-detail">
        <div className="page-content">
          <p>Portfolio item not found.</p>
          <button onClick={() => navigate('/portfolio')} className="back-button">
            Back to Portfolio
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="page portfolio-detail">
      <div className="page-content">
        <button onClick={() => navigate('/portfolio')} className="back-button">
          ← Back to Portfolio
        </button>
        <h1 className="portfolio-detail-title">{portfolioItem.title}</h1>
        <div className="portfolio-detail-content">
          {renderContent()}
        </div>
      </div>
    </div>
  )
}

export default PortfolioDetail


