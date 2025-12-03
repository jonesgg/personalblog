import './Blog.css'

function Blog() {
  return (
    <div className="page blog">
      <div className="page-content">
        <h1 className="page-title">Blog</h1>
        <div className="blog-content">
          <div className="blog-post">
            <div className="blog-post-header">
              <h2>Blog Post Title</h2>
              <span className="blog-post-date">January 1, 2024</span>
            </div>
            <p className="blog-post-excerpt">
              This is a sample blog post excerpt. Your blog posts will appear here.
              You can add more posts as you create content for your blog.
            </p>
            <a href="#" className="blog-read-more">Read More →</a>
          </div>
          
          <div className="blog-post">
            <div className="blog-post-header">
              <h2>Another Blog Post</h2>
              <span className="blog-post-date">December 15, 2023</span>
            </div>
            <p className="blog-post-excerpt">
              Another example blog post. This section will be populated with your actual blog content
              when you integrate with your backend.
            </p>
            <a href="#" className="blog-read-more">Read More →</a>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Blog

