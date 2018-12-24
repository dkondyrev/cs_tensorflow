const MODEL_URL = './tfjs_model_mul/tensorflowjs_model_mul_512.pb';
const WEIGHTS_URL = './tfjs_model_mul/weights_manifest.json';

function log(message) {
  console.log(message);
}

async function exec_model () {
  let model = await tf.loadFrozenModel(MODEL_URL, WEIGHTS_URL);
  log("model loaded");

  const n = 512;
  const n2 = n * n;

  var x_array = new Float32Array(n2);
  var y_array = new Float32Array(n2);
  for (let i = 0; i < n2; i++) {
    x_array[i] = i;
    y_array[i] = i * 2;
  }

  let n_times = 100;

  var time = performance.now();

  for(let i = 0; i < n_times; i++) {
    const xs = tf.tensor2d(x_array, [n, n]);
    const ys = tf.tensor2d(y_array, [n, n]);

    var x_y_resilt = await model.execute({x_hold: xs, y_hold: ys});
  }

  time = performance.now() - time;
  log('Total time: ' + time + ' ms');
  log('Mean time: ' + time / n_times + ' ms');

  document.getElementById("container").textContent = 'Mean time: ' + time / n_times + ' ms';
}

exec_model();
