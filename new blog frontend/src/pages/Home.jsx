import './Home.css'

function Home() {
  return (
    <div className="page home">
      <div className="home-hero">
        <h1 className="home-title">Welcome</h1>
        <p className="home-subtitle">
          Developer, Designer, Creative Thinker
        </p>
        <p className="home-description">
          Welcome to my personal space where I share my work, thoughts, and journey.
        </p>
      </div>

      <div className="home-content">
        <section className="home-section about-section">
          <h2 className="section-title">About Me</h2>
          <div className="about-content">
            <p>
              I'm Grant Rencher, a passionate developer and creative professional.
              This is my personal space where I share my experiences, projects, and insights.
            </p>
            <p>
              I love building things that matter, solving complex problems, and continuously learning.
              When I'm not coding, you'll find me exploring new technologies, contributing to open source,
              or sharing my thoughts through writing.
            </p>
          </div>
        </section>

        <section className="home-section resume-section">
          <h2 className="section-title">Resume</h2>
          <div className="resume-content">
            <div className="resume-subsection">
              <h3>Experience</h3>
              <div className="resume-item">
                <h4>Your Position Title</h4>
                <p className="resume-meta">Company Name | Date Range</p>
                <p>Description of your role and achievements...</p>
              </div>
            </div>
            
            <div className="resume-subsection">
              <h3>Education</h3>
              <div className="resume-item">
                <h4>Degree</h4>
                <p className="resume-meta">Institution | Year</p>
              </div>
            </div>
            
            <div className="resume-subsection">
              <h3>Skills</h3>
              <div className="skills-grid">
                <span className="skill-tag">React</span>
                <span className="skill-tag">JavaScript</span>
                <span className="skill-tag">Node.js</span>
                <span className="skill-tag">CSS</span>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  )
}

export default Home

