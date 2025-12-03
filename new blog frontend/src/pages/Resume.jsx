import './Resume.css'

function Resume() {
  return (
    <div className="page resume">
      <div className="page-content">
        <h1 className="page-title">Resume</h1>
        <div className="resume-content">
          <section className="resume-section">
            <h2>Experience</h2>
            <div className="resume-item">
              <h3>Your Position Title</h3>
              <p className="resume-meta">Company Name | Date Range</p>
              <p>Description of your role and achievements...</p>
            </div>
          </section>
          
          <section className="resume-section">
            <h2>Education</h2>
            <div className="resume-item">
              <h3>Degree</h3>
              <p className="resume-meta">Institution | Year</p>
            </div>
          </section>
          
          <section className="resume-section">
            <h2>Skills</h2>
            <div className="skills-grid">
              <span className="skill-tag">React</span>
              <span className="skill-tag">JavaScript</span>
              <span className="skill-tag">Node.js</span>
              <span className="skill-tag">CSS</span>
            </div>
          </section>
        </div>
      </div>
    </div>
  )
}

export default Resume

