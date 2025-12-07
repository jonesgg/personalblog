**Project Purpose and Goals**

* Create a personal site to showcase my skills and experience to employers. This will come in the form of a resume and portfolio
* Create a blog as part of my personal site that I can use to express my thoughts on the world (Programming, Gospel, Philosophy, Hobbies)

**Pitch Message in Teams**
As many of us know the current job market is a very competitive one. To get hired in today's market one must work very hard to show off their skills. One area that I've identified that I could do better on is having a website to include on my resume and job applications. This website will include my resume, as well as a comprehensive list of all projects I've worked on as my portfolio. Each portfolio item will have a separate page. Portfolio and resume data will be stored in the database.
 
In addition to that I've always wanted to express some of my thoughts in a blog. I know there are avenues like Medium where you can make blogposts but I want to create something that's mine where I can express my thoughts. My blog will be built into the personal site and will have all data stored in the database, just like the portfolio.
 
There will be private endpoints built to retrieve and create resume items, portfolio items, and blogposts.

**Site Layout**

(All images are early goals of what I imagine the site to look like)

Main Page - Contains Resume and blurb about me

<img width="1459" height="1247" alt="Screenshot 2025-12-03 at 11 44 18 AM" src="https://github.com/user-attachments/assets/fc33bcde-e71d-437f-be98-9f33f700a59b" />

Portfolio - Contains a list of relevant projects I worked on. Clicking on one brings up a page giving greater detail into the project.

<img width="1492" height="608" alt="Screenshot 2025-12-03 at 11 44 26 AM" src="https://github.com/user-attachments/assets/e07aa922-6dea-49ac-b147-83740c39435d" />

Blog - Contains a list published blogposts. Clicking on one displays the blogpost content in a new page.

<img width="1414" height="890" alt="Screenshot 2025-12-03 at 11 44 34 AM" src="https://github.com/user-attachments/assets/b822c4a0-1f8b-4efc-b0f7-12d5fc35c9a3" />

**Data Access**

We will be using DynamoDB with three tables along with an S3 Bucket, one table for resume, one for portfolio, and one for blogposts

<img width="721" height="518" alt="Screenshot 2025-12-03 at 11 33 27 AM" src="https://github.com/user-attachments/assets/51a1ddeb-c523-4952-8cb5-7d23aeb9e441" />

**Site Architecture**

Frontend - ReactJS
Backend - API Gateway, Lambda, and DynamoDB
Other - Terraform for deployment, Cloudwatch for debugging and logs, Route53 for domain control

<img width="546" height="800" alt="Screenshot 2025-12-03 at 11 41 04 AM" src="https://github.com/user-attachments/assets/8bcc7370-770b-4376-8dc5-266248c98907" />


**Initial Project Timeline and Goals**

December 1 - Idea generation and project selection
December 2 - Project design and bootstrapping
December 3 - Lambda and backend design
December 4 - Frontend finishing up
December 5 - Deployment of project

**Actual Time log**
2.5 hrs Dec 1 Brainstorming, designing architecture
4 hrs Dec 2 Project bootstrapping, git setup, backend framework
5.5 hrs dec 3 pitch, bulk of backend work, some frontend work
5 hrs dec 4 frontend design, finish up backend, start working more on frontend 
6 hrs dec 5 big fixes and improvements to backend, most of frontend work, test data population, deployment
6 hrs dec bug fixes, deployment issues, presentation planning

**Final Report**
What did I learn?
* In this project I learned about effective planning and execution of a full stack applicaiton.
* I learned about building effective color schemes.
* I learned about common AWS strategies including S3 bucket invalidations and error handling.

AI - My project doesn't use AI *yet!*

My Interest - This project is interesting to me becuase I've always been trying to build a good blog and portfolio site. I've tried and failed a couple times already so this was a great chance to finally do it. I will use this to give my thoughts on the world and hopefully get me a job.

Authentication - The only thing that needs to be secured are the create api endpoints. To prevent misuse I have a JWT token system in place ensuring that only I can use the create APIs.

Failover strategy - Given excessive traffic to the site my plan is to start restricting offender IP addresses or simply turn it off until I find a faster solution.

Use of AI - I used AI for difficult CSS problems and also for terraform setup. To me those two things are perfect use cases for AI.
