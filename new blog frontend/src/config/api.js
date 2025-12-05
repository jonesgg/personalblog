// API Configuration
// Update this with your actual API base URL
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'https://0sjwzpf8e0.execute-api.us-east-1.amazonaws.com/dev';

export const API_ENDPOINTS = {
  RESUME: `${API_BASE_URL}/resume`,
  BLOGPOST: `${API_BASE_URL}/blogpost`,
  PORTFOLIO: `${API_BASE_URL}/portfolio`,
  IMAGE_UPLOAD: `${API_BASE_URL}/image/upload`,
};

export default API_BASE_URL;

