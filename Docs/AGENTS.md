# 🤖 StryVr Intelligence Agents

StryVr uses modular "agents" to drive insights, automation, and personalization throughout the workplace performance platform. Each agent is designed to handle a specific responsibility and can operate independently or as part of a larger flow.

---

## 1. GrowthAnalyzerAgent

**Purpose:**  
Analyzes a user’s performance, learning trajectory, and team impact to provide growth potential feedback.

**Inputs:**  
- SkillProgress data  
- ReportModel entries  
- Behavior feedback scores  
- Career milestones  

**Outputs:**  
- Growth potential score  
- Career path suggestions  
- Readiness for promotion  

**File Location:**  
`StryVrModule/Services/GrowthAnalyzerAgent.swift` *(planned)*

**Tech Stack:**  
Swift, internal models

**AI Use:**  
Planned (predictive scoring and growth trajectory analysis)

**Triggered When:**  
A new report is submitted or when viewing the Employee Insights Dashboard.

---

## 2. SkillMatrixAgent

**Purpose:**  
Analyzes team-wide skill coverage to identify gaps and redundancies.

**Inputs:**  
- SkillMatrixEntry[]  
- Team structure data  
- Assigned project requirements  

**Outputs:**  
- Skill radar chart  
- Gap analysis  
- Priority flags for upskilling  

**File Location:**  
`StryVrModule/Services/SkillMatrixAgent.swift` *(planned)*

**Tech Stack:**  
Swift, Charts, TeamModel

**AI Use:**  
No (uses deterministic logic)

**Triggered When:**  
Managers view team dashboard or assign new project roles.

---

## 3. FeedbackSuggesterAgent

**Purpose:**  
Suggests constructive feedback or phrasing based on behavior data and tone analysis.

**Inputs:**  
- Behavior scores  
- Role-specific feedback tags  
- Weekly check-ins  

**Outputs:**  
- Suggested feedback messages  
- Tone options (professional, growth-oriented, anonymous)  

**File Location:**  
`StryVrModule/Services/FeedbackSuggesterAgent.swift` *(planned)*

**Tech Stack:**  
Swift, NLP API integration

**AI Use:**  
Yes (natural language suggestion engine)

**Triggered When:**  
User gives behavior feedback or completes a team review.

---

## 4. ResumeFormatterAgent

**Purpose:**  
Generates a downloadable résumé from verified learning, work history, and skills.

**Inputs:**  
- LearningReport  
- Verified skills  
- Feedback summary  
- User profile  

**Outputs:**  
- PDF résumé  
- Downloadable .pdf file  

**File Location:**  
`Utils/ResumePDFGenerator.swift`, `Views/Reports/StryvrProResumeView.swift`

**Tech Stack:**  
Swift, PDFKit

**AI Use:**  
Planned (phrasing enhancements and layout optimization)

**Triggered When:**  
User exports résumé in premium or enterprise mode.

---

## 5. ReportInsightsAgent

**Purpose:**  
Summarizes strengths, blind spots, and patterns from a user’s report history.

**Inputs:**  
- ReportModel[]  
- Skill milestones  
- Manager feedback  
- Team dynamics  

**Outputs:**  
- Report summary  
- Recommended focus areas  
- Team sentiment insight  

**File Location:**  
`Services/ReportGeneration.swift`

**Tech Stack:**  
Swift, planned AI summarization

**AI Use:**  
Yes (summary generation and insight extraction)

**Triggered When:**  
A report is reviewed by the user or supervisor.

---

## 6. NotificationAgent

**Purpose:**  
Delivers reminders and alerts based on user activity, deadlines, and feedback loops.

**Inputs:**  
- Daily streak status  
- Challenge participation  
- Report events  
- Skill completion  

**Outputs:**  
- Push notifications  
- App banners  
- Achievement pings  

**File Location:**  
`Services/NotificationService.swift`

**Tech Stack:**  
Swift, Firebase Messaging

**AI Use:**  
Planned (engagement prediction logic)

**Triggered When:**  
User is inactive, completes milestones, or misses tasks.

---

## 7. GoalTrackerAgent

**Purpose:**  
Tracks employee or personal learning goals and aligns them with StryVr activity.

**Inputs:**  
- User-set goals  
- Learning progress  
- Report alignment  

**Outputs:**  
- Goal status  
- Progress tracking  
- Alignment suggestions  

**File Location:**  
`StryVrModule/Services/GoalTrackerAgent.swift` *(planned)*

**Tech Stack:**  
Swift

**AI Use:**  
No (logic-based tracking)

**Triggered When:**  
User sets or updates a career or skill goal.

---

## 8. BehaviorTrendAgent

**Purpose:**  
Identifies behavioral patterns over time and provides alerts for burnout, disengagement, or growth.

**Inputs:**  
- Weekly feedback logs  
- Task completion rates  
- Streak consistency  

**Outputs:**  
- Trend line reports  
- Burnout alerts  
- Encouragement nudges  

**File Location:**  
`StryVrModule/Services/BehaviorTrendAgent.swift` *(planned)*

**Tech Stack:**  
Swift

**AI Use:**  
Yes — pattern recognition via analytics

**Triggered When:**  
System reviews user behavior after 1–4 week cycles.

---

## 9. AIContentPersonalizer

**Purpose:**  
Surfaces learning content and report highlights personalized to user roles and strengths.

**Inputs:**  
- User goals  
- Engagement history  
- Skill tags  

**Outputs:**  
- Personalized feed  
- Content card prioritization  

**File Location:**  
`StryVrModule/Services/AIRecommendationService.swift`

**Tech Stack:**  
Swift, optional LLM integration (future)

**AI Use:**  
Yes — uses interest mapping and prioritization scoring

**Triggered When:**  
User opens dashboard or requests recommended content.
