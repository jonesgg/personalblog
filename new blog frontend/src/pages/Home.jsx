import { useState, useEffect } from 'react'
import './Home.css'
import { API_ENDPOINTS } from '../config/api'
import profileImage from '../images/profile.jpg'

function Home() {
  const [resumeItems, setResumeItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    const fetchResumeItems = async () => {
      try {
        setLoading(true)
        setError(null)
        const response = await fetch(API_ENDPOINTS.RESUME)
        
        if (!response.ok) {
          throw new Error(`Failed to fetch resume items: ${response.statusText}`)
        }

        const data = await response.json()
        
        // Handle Lambda response format (statusCode, headers, body)
        let resumeData = data
        if (data.statusCode && data.body) {
          // If body is a string, parse it
          resumeData = typeof data.body === 'string' ? JSON.parse(data.body) : data.body
        }

        if (resumeData.resume && Array.isArray(resumeData.resume)) {
          // Sort by start_month descending (most recent first)
          const sorted = [...resumeData.resume].sort((a, b) => {
            return b.start_month.localeCompare(a.start_month)
          })
          setResumeItems(sorted)
        } else {
          setResumeItems([])
        }
      } catch (err) {
        console.error('Error fetching resume items:', err)
        setError(err.message)
        setResumeItems([])
      } finally {
        setLoading(false)
      }
    }

    fetchResumeItems()
  }, [])

  const formatDateRange = (startMonth, endMonth) => {
    const formatMonth = (monthStr) => {
      if (!monthStr) return ''
      const [year, month] = monthStr.split('-')
      const date = new Date(year, parseInt(month) - 1)
      return date.toLocaleDateString('en-US', { month: 'short', year: 'numeric' })
    }

    const start = formatMonth(startMonth)
    const end = endMonth ? formatMonth(endMonth) : 'Present'
    return `${start} - ${end}`
  }

  return (
    <div className="page home">
      <div className="home-hero">
        <img src={profileImage} alt="Grant Rencher" className="profile-image" />
        <h1 className="home-title">Grant Rencher</h1>
        {/* <p className="home-subtitle">
          Software Engineer
        </p> */}
        <p className="home-description">
            I'm a Software engineer with experience delivering full-stack solutions, from scalable backend systems to intuitive frontend
            applications. Skilled at contributing across the entire software development life cycle, with strengths in collaboration,
            adaptability, and problem-solving. Proven track record of building impactful products that improve customer
            experiences and operational efficiency.
        </p>
      </div>

      <div className="home-content">
        {/* <section className="home-section about-section">
          <h2 className="section-title">About Me</h2>
          <div className="about-content">
            <p>
            I'm a Software engineer with experience delivering full-stack solutions, from scalable backend systems to intuitive frontend
            applications. Skilled at contributing across the entire software development life cycle, with strengths in collaboration,
            adaptability, and problem-solving. Proven track record of building impactful products that improve customer
            experiences and operational efficiency.
            </p>
            <p>
              I love building things that matter, solving complex problems, and continuously learning.
              When I'm not coding, you'll find me exploring new technologies, contributing to open source,
              or sharing my thoughts through writing.
            </p>
          </div>
        </section> */}

        <section className="home-section resume-section">
          <h2 className="section-title">Resume</h2>
          <div className="resume-content">
            <div className="resume-subsection">
              <h3>Experience</h3>
              {loading && <p>Loading experience...</p>}
              {error && <p style={{ color: 'red' }}>Error: {error}</p>}
              {!loading && !error && resumeItems.length === 0 && (
                <p>No experience items found.</p>
              )}
              {!loading && !error && resumeItems.map((item) => (
                <div key={item.id} className="resume-item">
                  {item.image_url && (
                    <img 
                      src={item.image_url} 
                      alt={item.company_name || "Company logo"} 
                    />
                  )}
                  {item.title && (
                    <h4>{item.title}</h4>
                  )}
                  {item.company_name && (
                    <p className="resume-company">{item.company_name}</p>
                  )}
                  <p className="resume-meta">{formatDateRange(item.start_month, item.end_month)}</p>
                  {item.description && (
                    <p>{item.description}</p>
                  )}
                </div>
              ))}
            </div>
            
            <div className="resume-subsection">
              <h3>Education</h3>
              <div className="resume-item">
                <h4>B.S. in Computer Science</h4>
                <p className="resume-meta">Brigham Young University | April 2026 | 3.96 GPA</p>
              </div>
            </div>
            
            <div className="resume-subsection">
              <h3>Skills</h3>
              <div className="skills-grid">
                <span className="skill-tag">Object-Oriented Software Development and Testing</span>
                <span className="skill-tag">Full Stack Web Development</span>
                <span className="skill-tag">Database Management and Design (SQL, NoSQL)</span>
                <span className="skill-tag">ReactJS</span>
                <span className="skill-tag">AWS Product Deployment and Management</span>
                <span className="skill-tag">Agile/Scrum Methodologies</span>
                <span className="skill-tag">Docker</span>
                <span className="skill-tag">Linux Systems</span>
                <span className="skill-tag">Kafka/Event Queues</span>
                <span className="skill-tag">SQL</span>
                <span className="skill-tag">NoSQL</span>
                <span className="skill-tag">Version Control</span>
                <span className="skill-tag">Python</span>
                <span className="skill-tag">Java</span>
                <span className="skill-tag">Typescript</span>
              </div>
            </div>
          </div>
        </section>
      </div>
    </div>
  )
}

export default Home

