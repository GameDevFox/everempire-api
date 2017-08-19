console.log('EVENT INIT');

const data = JSON.parse('<%= data.to_json %>');
console.log(data);

const e = new Event('<%= type.to_s %>');
e.data = data;
opener.dispatchEvent(e);

window.close();
