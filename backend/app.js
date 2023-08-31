import { createRandomUsers } from './create_fake.js';
import express from 'express';

const app = express()
const port = 3000

var users = createRandomUsers(10);
users.push({
  userId: '03c4589a-19ba-462a-add1-d7e1aadc8598',
  username: 'alma.reka',
  email: 'iloveu@gmail.com',
  avatar: 'https://hips.hearstapps.com/hmg-prod/images/cute-cat-photos-1593441022.jpg',
  password: 'odzAw9212hj27F8',
  birthdate: new Date('1973-07-10T16:45:29.626Z'),
  registeredAt: new Date('2023-01-13T09:47:31.304Z')
})

app.get('/', (_, res) => {
  res.json({message: 'I\'m alive!'})
})
app.get('/user/all', (_, res) => {
  res.json({users: users})
})

app.get('/user/count', (_, res) => {
  res.json({users_count: users.length})
})

app.get('/user/:id', (req, res) => {
  res.json({user: users.find((u) => u.userId === req.params.id)})
})

app.delete('/user/:id', (req, res) => {
  const userIndexToDelete = users.findIndex(u => u.userId === req.params.id);

  if (userIndexToDelete !== -1) {
    users.splice(userIndexToDelete, 1);
    res.sendStatus(200)
  } else {
    res.status(404).send('User not found');
  }
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`)
})
