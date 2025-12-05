import { useState, useEffect } from 'react'
import { useNavigate, useSearchParams } from 'react-router-dom'
import './Blog.css'
import { API_ENDPOINTS } from '../config/api'

function Blog() {
  const [blogPosts, setBlogPosts] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const selectedTag = searchParams.get('tag')

  useEffect(() => {
    const fetchBlogPosts = async () => {
      try {
        setLoading(true)
        setError(null)
        
        // Build query parameters
        const params = new URLSearchParams()
        params.append('sort', 'date')
        params.append('order', 'desc')
        if (selectedTag) {
          params.append('tag', selectedTag)
        }
        
        const response = await fetch(`${API_ENDPOINTS.BLOGPOST}?${params.toString()}`)
        
        if (!response.ok) {
          throw new Error(`Failed to fetch blog posts: ${response.statusText}`)
        }

        const data = await response.json()
        
        // Handle Lambda response format (statusCode, headers, body)
        let blogData = data
        if (data.statusCode && data.body) {
          // If body is a string, parse it
          blogData = typeof data.body === 'string' ? JSON.parse(data.body) : data.body
        }

        if (blogData.blogposts && Array.isArray(blogData.blogposts)) {
          setBlogPosts(blogData.blogposts)
        } else {
          setBlogPosts([])
        }
      } catch (err) {
        console.error('Error fetching blog posts:', err)
        setError(err.message)
        setBlogPosts([])
      } finally {
        setLoading(false)
      }
    }

    fetchBlogPosts()
  }, [selectedTag])

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

  const handlePostClick = (slug) => {
    navigate(`/blog/${slug}`)
  }

  const handleClearFilter = () => {
    navigate('/blog')
  }

  return (
    <div className="page blog">
      <div className="page-content">
        <div className="blog-header">
          <h1 className="page-title">Blog</h1>
          {selectedTag && (
            <div className="blog-filter-info">
              <span>Filtered by tag: <strong>{selectedTag}</strong></span>
              <button onClick={handleClearFilter} className="clear-filter-button">
                Clear Filter
              </button>
            </div>
          )}
        </div>
        {loading && <p>Loading blog posts...</p>}
        {error && <p style={{ color: 'red' }}>Error: {error}</p>}
        {!loading && !error && blogPosts.length === 0 && (
          <p>No blog posts found{selectedTag ? ` with tag "${selectedTag}"` : ''}.</p>
        )}
        {!loading && !error && blogPosts.length > 0 && (
          <div className="blog-content">
            {blogPosts.map((post) => (
              <div 
                key={post.slug} 
                className="blog-post"
                onClick={() => handlePostClick(post.slug)}
                style={{ cursor: 'pointer' }}
              >
                {post.title_image_url && (
                  <img 
                    src={post.title_image_url} 
                    alt={post.title} 
                    className="blog-post-image"
                  />
                )}
                <div className="blog-post-header">
                  <h2>{post.title}</h2>
                  <span className="blog-post-date">{formatDate(post.date)}</span>
                </div>
                {post.summary && (
                  <p className="blog-post-excerpt">{post.summary}</p>
                )}
                <div className="blog-read-more">Read More →</div>
              </div>
            ))}
          </div>
        )}
      </div>
    </div>
  )
}

export default Blog

