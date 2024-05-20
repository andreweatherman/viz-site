<script>
const dogImages = Array.from({ length: 20 }, (_, i) => `cooper/cooper_${i + 1}.jpeg`);

const getRandomDogImage = () => {
  const randomIndex = Math.floor(Math.random() * dogImages.length);
  return dogImages[randomIndex];
};

const RandomDogImage = () => {
  const randomDogImage = getRandomDogImage();

  return (
    `<img src="${randomDogImage}" alt="Random Dog" style="max-width: 100%; height: auto;" />`
  );
};

// On window load, set the random dog image
window.onload = function() {
  const container = document.getElementById("random-dog-image-container");
  container.innerHTML = RandomDogImage();
};
</script>
