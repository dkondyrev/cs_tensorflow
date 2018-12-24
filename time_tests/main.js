var memory = new WebAssembly.Memory({initial:10000, maximum:32767});

fetch('mul_512_opt.wasm').then(response =>
  response.arrayBuffer()
).then(bytes => WebAssembly.instantiate(bytes, { js: { mem: memory } })).then(obj => {
  instance = obj.instance;

  let n = 512;
  let n2 = n * n;
  let memory_array = new Float32Array(memory.buffer, 0, n2 * 3);

  for (let i = 0; i < n2; i++) {
    memory_array[i] = i;
    memory_array[i + n2] = i * 2;
  }

  var time = performance.now();

  let n_times = 1;
  for (let i = 0; i < n_times; i++) {
    result_offset = instance.exports.entry(0, 4 * n2);
  }

  time = performance.now() - time;
  console.log('Total time: ' + time + ' ms');
  console.log('Mean time: ' + time / n_times + ' ms');

  document.getElementById("container").textContent = 'Mean time: ' + time / n_times + ' ms';

}).catch(console.error);
