# applicationtrackerInstructions for LLM Implementation: Job Application Tracker
Project Goal
Build a web application to track job applications in a Jira-like Kanban format.
The application must support users, job applications, interview stages, attachments, and optional tags.
The goal is to keep the implementation simple but extensible.
Tech Stack
Frontend: Next.js (React + TypeScript)
Styling: TailwindCSS
State management: React Query (for API sync)
Kanban board: @dnd-kit or react-beautiful-dnd
Backend:
Next.js API routes (Node.js, TypeScript)
Authentication: NextAuth.js (Email + Google OAuth)
Database:
PostgreSQL (via Prisma ORM)
Hosted on Supabase or Neon
Deployment:
Vercel (frontend + backend)
Supabase/Neon (database + storage)
Storage: Supabase storage or S3-compatible bucket for attachments
Database Schema
model User {
  id            String   @id @default(uuid())
  name          String?
  email         String   @unique
  passwordHash  String?
  provider      String
  createdAt     DateTime @default(now())
  updatedAt     DateTime @updatedAt

  applications  JobApplication[]
  tags          Tag[]
}

model JobApplication {
  id             String           @id @default(uuid())
  userId         String
  company        String
  role           String
  jobLink        String?
  status         ApplicationStatus
  appliedDate    DateTime?
  followUpDate   DateTime?
  notes          String?

  createdAt      DateTime @default(now())
  updatedAt      DateTime @updatedAt

  user           User              @relation(fields: [userId], references: [id])
  stages         InterviewStage[]
  attachments    Attachment[]
  tags           JobApplicationTag[]
}

model InterviewStage {
  id                String   @id @default(uuid())
  jobApplicationId  String
  stageName         String   // e.g., Phone Screen, Tech 1, Onsite
  scheduledDate     DateTime?
  outcome           String?  // Pending, Passed, Failed, Offer Extended
  notes             String?

  createdAt         DateTime @default(now())
  updatedAt         DateTime @updatedAt

  jobApplication    JobApplication @relation(fields: [jobApplicationId], references: [id])
}

model Attachment {
  id                String   @id @default(uuid())
  jobApplicationId  String
  fileUrl           String
  fileType          String   // resume, cover_letter, jd, misc
  uploadedAt        DateTime @default(now())

  jobApplication    JobApplication @relation(fields: [jobApplicationId], references: [id])
}

model Tag {
  id        String   @id @default(uuid())
  userId    String
  name      String
  color     String

  user      User      @relation(fields: [userId], references: [id])
  apps      JobApplicationTag[]
}

model JobApplicationTag {
  jobApplicationId String
  tagId            String

  jobApplication   JobApplication @relation(fields: [jobApplicationId], references: [id])
  tag              Tag            @relation(fields: [tagId], references: [id])

  @@id([jobApplicationId, tagId])
}

enum ApplicationStatus {
  WISHLIST
  APPLIED
  INTERVIEWING
  OFFER
  REJECTED
}
Required Features (MVP)
Authentication
Allow signup/login with email + Google OAuth using NextAuth.js.
Each user sees only their own applications.
Job Applications
CRUD operations (Create, Read, Update, Delete).
Fields: company, role, job link, status, applied date, follow-up date, notes.
Displayed on a Kanban board grouped by status.
Support drag-and-drop to update status.
Interview Stages
Each job application can have multiple interview stages.
Each stage includes: stageName, scheduledDate, outcome, notes.
Display stages inside job application detail view.
Attachments
Upload files (resume, job description, cover letters, misc).
Store links in DB, file in Supabase/S3.
Tags
Users can create tags (with optional color).
Tags can be applied to applications.
Applications can have multiple tags.
Optional Features (Future)
Reminders & notifications (follow-up dates).
Analytics: conversion rates, time in stage, total apps vs. offers.
Team/multi-user sharing.
Endpoints (REST API)
/api/applications (GET, POST)
/api/applications/[id] (GET, PUT, DELETE)
/api/applications/[id]/stages (GET, POST)
/api/applications/[id]/attachments (GET, POST, DELETE)
/api/tags (GET, POST)
/api/tags/[id] (DELETE)
UI Requirements
Kanban Board
Columns: Wishlist, Applied, Interviewing, Offer, Rejected.
Each card shows: company, role, current interview stage, tags.
Drag-and-drop to move between columns.
Application Detail Modal
Show all fields + notes.
List of interview stages (with add/edit/delete).
Attachments upload/view.
Tags management.
Search/Filter
Filter by company, role, tags, or status.
