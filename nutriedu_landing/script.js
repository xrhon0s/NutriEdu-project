const selections = {
  protein: "",
  carb: "",
  vegetable: "",
};

const labels = {
  protein: "Proteína",
  carb: "Carbohidrato",
  vegetable: "Vegetal",
};

const title = document.querySelector("#recipeTitle");
const body = document.querySelector("#recipeBody");
const proteinTag = document.querySelector("#proteinTag");
const carbTag = document.querySelector("#carbTag");
const vegTag = document.querySelector("#vegTag");

document.querySelectorAll(".ingredient-picker button").forEach((button) => {
  button.addEventListener("click", () => {
    const type = button.dataset.type;
    const wasSelected = button.classList.contains("is-selected");

    document
      .querySelectorAll(`.ingredient-picker button[data-type="${type}"]`)
      .forEach((item) => item.classList.remove("is-selected"));

    if (wasSelected) {
      selections[type] = "";
    } else {
      selections[type] = button.textContent;
      button.classList.add("is-selected");
    }

    updateRecipe();
  });
});

function updateRecipe() {
  proteinTag.textContent = selections.protein
    ? `${labels.protein}: ${selections.protein}`
    : "Proteína pendiente";
  carbTag.textContent = selections.carb
    ? `${labels.carb}: ${selections.carb}`
    : "Carbohidrato pendiente";
  vegTag.textContent = selections.vegetable
    ? `${labels.vegetable}: ${selections.vegetable}`
    : "Vegetal pendiente";

  const selectedCount = Object.values(selections).filter(Boolean).length;

  if (selectedCount === 3) {
    title.textContent = `${selections.protein} salteado con ${selections.vegetable}`;
    body.textContent = `Base de ${selections.carb.toLowerCase()}, proteína dorada y vegetal salteado. Técnica recomendada: cocinar el carbohidrato, saltear ${selections.protein.toLowerCase()} y terminar con ${selections.vegetable.toLowerCase()}.`;
    return;
  }

  if (selectedCount > 0) {
    title.textContent = "Patrón incompleto, pero útil";
    body.textContent =
      "La plataforma detecta lo que ya tienes y te pide el componente faltante para construir una comida balanceada.";
    return;
  }

  title.textContent = "Bowl universitario inteligente";
  body.textContent =
    "Elige una proteína, un carbohidrato y un vegetal para completar el patrón base.";
}
