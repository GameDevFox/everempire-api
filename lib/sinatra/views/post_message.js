console.log('POST MESSAGE');

const message = JSON.parse('<%= message.to_json %>');
console.log(message);

opener.postMessage(message, '<%= target_origin %>');

window.close();
