import { useState, useEffect } from 'react'
import { useParams, useNavigate } from 'react-router-dom'
import './BlogDetail.css'
import { API_ENDPOINTS } from '../config/api'

function BlogDetail() {
  const { slug } = useParams()
  const navigate = useNavigate()
  const [blogPost, setBlogPost] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    const fetchBlogPost = async () => {
      if (!slug) return

      try {
        setLoading(true)
        setError(null)
        const response = await fetch(`${API_ENDPOINTS.BLOGPOST}/${slug}`)
        
        if (!response.ok) {
          if (response.status === 404) {
            throw new Error('Blog post not found')
          }
          throw new Error(`Failed to fetch blog post: ${response.statusText}`)
        }

        const data = await response.json()
        
        // Handle Lambda response format (statusCode, headers, body)
        let blogData = data
        if (data.statusCode && data.body) {
          // If body is a string, parse it
          blogData = typeof data.body === 'string' ? JSON.parse(data.body) : data.body
        }

        setBlogPost(blogData)
      } catch (err) {
        console.error('Error fetching blog post:', err)
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchBlogPost()
  }, [slug])

  const formatDate = (dateStr) => {
    if (!dateStr) return ''
    // Parse date string (YYYY-MM-DD) as local date to avoid timezone issues
    const [year, month, day] = dateStr.split('-').map(Number)
    const date = new Date(year, month - 1, day)
    return date.toLocaleDateString('en-US', { 
      year: 'numeric', 
      month: 'long', 
      day: 'numeric' 
    })
  }

  const renderContent = () => {
    if (!blogPost || !blogPost.content || !Array.isArray(blogPost.content)) {
      return null
    }

    return blogPost.content.map((item, index) => {
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
            alt="Blog content" 
            className="content-image"
          />
        )
      }
      return null
    })
  }

  if (loading) {
    return (
      <div className="page blog-detail">
        <div className="page-content">
          <p>Loading blog post...</p>
        </div>
      </div>
    )
  }

  if (error) {
    return (
      <div className="page blog-detail">
        <div className="page-content">
          <p style={{ color: 'red' }}>Error: {error}</p>
          <button onClick={() => navigate('/blog')} className="back-button">
            Back to Blog
          </button>
        </div>
      </div>
    )
  }

  if (!blogPost) {
    return (
      <div className="page blog-detail">
        <div className="page-content">
          <p>Blog post not found.</p>
          <button onClick={() => navigate('/blog')} className="back-button">
            Back to Blog
          </button>
        </div>
      </div>
    )
  }

  return (
    <div className="page blog-detail">
      <div className="page-content">
        <button onClick={() => navigate('/blog')} className="back-button">
          ← Back to Blog
        </button>
        <h1 className="blog-detail-title">{blogPost.title}</h1>
        {blogPost.title_image_url && (
          <img 
            src={blogPost.title_image_url} 
            alt={blogPost.title} 
            className="blog-detail-title-image"
          />
        )}
        <div className="blog-detail-date">{formatDate(blogPost.date)}</div>
        <div className="blog-detail-content">
          {renderContent()}
        </div>
        {blogPost.tags && blogPost.tags.length > 0 && (
          <div className="blog-detail-tags">
            <span className="tags-label">Tags: </span>
            {blogPost.tags.map((tag, index) => (
              <button
                key={index}
                className="blog-tag"
                onClick={() => navigate(`/blog?tag=${encodeURIComponent(tag)}`)}
              >
                {tag}
              </button>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

export default BlogDetail

