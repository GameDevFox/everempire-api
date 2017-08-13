console.log('EVENT INIT');

const authHash = JSON.parse('<%= data.to_json %>');
console.log(authHash);

const e = new Event('<%= type.to_s %>');
e.data = authHash;
opener.dispatchEvent(e)

window.close();
