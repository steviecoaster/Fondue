// Create a button
var button = document.createElement('button');
button.innerText = 'Toggle dark mode';
button.style.position = 'fixed';
button.style.top = '10px';
button.style.right = '10px';
document.body.appendChild(button);

// Add an event listener to the button
button.addEventListener('click', function() {
    document.body.classList.toggle('dark-mode');
});