import { faker } from '@faker-js/faker';

export function createRandomUsers(count = 1) {
  let users = [];
  for(let i = 0; i < count; i++) {
    let user = {
      userId: faker.string.uuid(),
      username: faker.internet.userName(),
      email: faker.internet.email(),
      avatar: faker.image.avatar(),
      password: faker.internet.password(),
      birthdate: faker.date.birthdate(),
      registeredAt: faker.date.past(),
    };

    if (count === 1) {
      return user;
    }
    users.push(user);
  }
  return users;
}
