const natsSteaming = require('node-nats-streaming');

Promise.resolve().then(async () => {
  //
  await wait(5000);
  console.log('Connection...');
  const stan = natsSteaming.connect(
    'nats-demo-stan',
    'test',
    'nats://nats-demo:4222'
  );
  stan.on('connect', () => {
    console.log('Connected...');
  });

  stan.on('error', error => {
    console.log(error);
  });

  await wait(2000);
  console.log('Publish 1 message on topic1');
  stan.publish(
    'test.topic1',
    `Message: ${new Date().toISOString()}`,
    (err, guid) => {
      if (err) {
        console.log('publish failed: ' + err);
      } else {
        console.log(`Published (guid: ${guid})`);
      }
    }
  );
  console.log('Publish 1 message on topic2');
  stan.publish(
    'test.topic2',
    `Message: ${new Date().toISOString()}`,
    (err, guid) => {
      if (err) {
        console.log('publish failed: ' + err);
      } else {
        console.log(`Published (guid: ${guid})`);
      }
    }
  );

  await wait(2000);
  console.log('Subscriber to Topic1');
  const opts1 = stan.subscriptionOptions().setDeliverAllAvailable();
  const subscription1 = stan.subscribe('test.topic1', opts1);
  subscription1.on('message', msg => {
    console.log(
      `[Topic: ${
        msg.subscription.subject
      }] #${msg.getSequence()} ${msg.getData()}`
    );
  });

  console.log('Subscriber to Topic2');
  const opts2 = stan.subscriptionOptions().setStartWithLastReceived();
  const subscription2 = stan.subscribe('test.topic2', opts2);
  subscription2.on('message', msg => {
    console.log(
      `[Topic: ${
        msg.subscription.subject
      }] #${msg.getSequence()} ${msg.getData()}`
    );
  });

  console.log('Publish 1 message on topic1');
  stan.publish(
    'test.topic1',
    `Message: ${new Date().toISOString()}`,
    (err, guid) => {
      if (err) {
        console.log('publish failed: ' + err);
      } else {
        console.log(`Published (guid: ${guid})`);
      }
    }
  );

  console.log('Publish 1 message on topic2');
  stan.publish(
    'test.topic2',
    `Message: ${new Date().toISOString()}`,
    (err, guid) => {
      if (err) {
        console.log('publish failed: ' + err);
      } else {
        console.log(`Published (guid: ${guid})`);
      }
    }
  );
});

function wait(time) {
  return new Promise(resolve => {
    setTimeout(() => {
      resolve();
    }, time);
  });
}
