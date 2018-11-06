fetch('../test.wasm').then(response =>
  response.arrayBuffer()
).then(bytes => WebAssembly.instantiate(bytes)).then(results => {
  instance = results.instance;

  let n = 10;
  let memory = new Uint32Array(instance.exports.memory.buffer, 0, n * 3);

  for (let i = 0; i < n; i++) {
    memory[i] = i;
    memory[i + n] = i ** 2;
  }

  instance.exports.addArrays(0, 4 * n, 8 * n, n);

  console.log("Result:");
  for (let i = 0; i < 3 * n; i++) {
    console.log(memory[i]);
  }
}).catch(console.error);
