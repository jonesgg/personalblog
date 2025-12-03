import './Portfolio.css'

function Portfolio() {
  return (
    <div className="page portfolio">
      <div className="page-content">
        <h1 className="page-title">Portfolio</h1>
        <div className="portfolio-grid">
          <div className="portfolio-item">
            <div className="portfolio-item-content">
              <h3>Project Title</h3>
              <p>Project description and technologies used...</p>
            </div>
          </div>
          <div className="portfolio-item">
            <div className="portfolio-item-content">
              <h3>Project Title</h3>
              <p>Project description and technologies used...</p>
            </div>
          </div>
          <div className="portfolio-item">
            <div className="portfolio-item-content">
              <h3>Project Title</h3>
              <p>Project description and technologies used...</p>
            </div>
          </div>
        </div>
      </div>
    </div>
  )
}

export default Portfolio

