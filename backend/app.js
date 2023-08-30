import { createRandomUsers } from './create_fake.js';
import express from 'express';

const app = express()
const port = 3000

var users = createRandomUsers(10);

app.get('/', (_, res) => {
  res.json({message: 'I\'m alive!'})
})

app.get('/users', (_, res) => {
  res.json({users: users})
})

app.get('/users/count', (_, res) => {
  res.json({users_count: users.length})
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
