import axios from 'axios';

const api = axios.create({
  headers: {
    authorization: 'true',
  },
});

export default api;
