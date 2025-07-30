# API Reference Update - 2025-07-30

## Available Endpoints

### `GET /api/test`
**Description**: Health check endpoint for API connectivity testing
**Parameters**: None
**Response**: 
```json
{
  "status": "success",
  "message": "API is running",
  "timestamp": "2025-07-30T14:30:00Z"
}
```

### `GET /api/test-storage`
**Description**: Test Firebase Storage connectivity and permissions
**Parameters**: None
**Response**:
```json
{
  "status": "success",
  "storage": "connected",
  "permissions": "valid"
}
```

### `GET /videos/:userId`
**Description**: Retrieve user's uploaded video recordings for analysis
**Parameters**: 
- `userId` (string): User's unique identifier
**Response**:
```json
{
  "videos": [
    {
      "id": "video_123",
      "userId": "user_456",
      "url": "https://storage.googleapis.com/...",
      "uploadedAt": "2025-07-30T14:30:00Z",
      "status": "processed"
    }
  ]
}
```

### `POST /upload`
**Description**: Upload video file for AI analysis and skill assessment
**Parameters**: 
- `video` (file): Video file (MP4, MOV, AVI)
- `userId` (string): User's unique identifier
**Response**:
```json
{
  "status": "success",
  "videoId": "video_789",
  "uploadUrl": "https://storage.googleapis.com/...",
  "processingStatus": "queued"
}
```

## Authentication
All endpoints require Firebase Auth token in Authorization header:
```
Authorization: Bearer <firebase_token>
```

## Error Responses
```json
{
  "error": "error_code",
  "message": "Human readable error message",
  "timestamp": "2025-07-30T14:30:00Z"
}
```

## Summary
- **Total endpoints**: 4
- **Authentication**: Firebase Auth required
- **File uploads**: Supported (video files)
- **Updated on**: 2025-07-30
- **Status**: Production ready

