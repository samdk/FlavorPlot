function getIngredients(ingredients, cb) {
    $.post('/ingredients', JSON.stringify(ingredients), cb, 'json');
}