async function copyWebhook() {
  const url = document.getElementById('webhook-url').textContent;
  await navigator.clipboard.writeText(url);
  const btn = document.querySelector('.input-group .icon-btn');
  btn.style.background = '#f0f7ff';
  setTimeout(() => btn.style.background = '', 1000);
}

async function analyzeRepo() {
  const input = document.getElementById('repo-input').value.trim();
  if (!input) return;
  const url = input.startsWith('http') ? input : 'https://' + input;
  
  const status = document.getElementById('status-msg');
  status.textContent = 'Analyzing...';

  await fetch('/analyze', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' },
    body: JSON.stringify({ repo_url: url })
  });

  status.textContent = '';
  loadResults();
}

async function loadResults() {
  const res = await fetch('/results');
  const rows = await res.json();
  const tbody = document.getElementById('results-body');

  if (!rows.length) {
    tbody.innerHTML = '<tr class="empty-row"><td colspan="5">No analyses yet. Paste a repo above or push a commit.</td></tr>';
    return;
  }

  tbody.innerHTML = rows.reverse().map(row => {
    const [id, repo_url, score, timestamp, commit_message, passed_checks] = row;
    const repoName = repo_url.replace('https://github.com/', '');
    const dots = Array.from({length: 7}, (_, i) =>
      `<span class="dot ${i < passed_checks ? 'passed' : 'failed'}"></span>`
    ).join('');
    return `<tr>
      <td class="repo-name">${repoName}</td>
      <td class="score">${score}%</td>
      <td class="commit-name">${commit_message || '—'}</td>
      <td><div class="checks-dots">${dots}</div></td>
      <td>${new Date(timestamp).toLocaleDateString()}</td>
    </tr>`;
  }).join('');
}

loadResults();