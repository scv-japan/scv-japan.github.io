const dialog = document.querySelector('dialog');
const preview = dialog.querySelector('img');
const title = dialog.querySelector('#photo-title');
const original = dialog.querySelector('.original');

document.querySelector('main').addEventListener('click', (event) => {
  const link = event.target.closest('.photos a');
  if (!link || event.metaKey || event.ctrlKey || event.shiftKey || event.altKey ||
      typeof dialog.showModal !== 'function') {
    return;
  }

  event.preventDefault();
  const thumbnail = link.querySelector('img');
  const width = thumbnail.getBoundingClientRect().width;
  dialog.style.setProperty('--photo-width', `${width * 2}px`);
  title.textContent = thumbnail.alt;
  original.href = link.dataset.original;
  preview.alt = thumbnail.alt;
  preview.src = link.href;
  dialog.showModal();
  dialog.scrollTop = 0;
});
dialog.addEventListener('click', (event) => {
  if (event.target === dialog) {
    const bounds = dialog.getBoundingClientRect();
    if (event.clientX < bounds.left || event.clientX > bounds.right ||
        event.clientY < bounds.top || event.clientY > bounds.bottom) {
      dialog.close();
    }
  }
});

