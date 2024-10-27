import axios from 'axios';

const API_URL = process.env.NEXT_PUBLIC_RAILS_API_URL;

export const apiClient = axios.create({
	baseURL: API_URL,
	headers: { 'Content-Type': 'application/json' },
});