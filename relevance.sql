select distinct name, recipe_id
from ingredient
where recipe_id in (
  select distinct recipe_id
  from ingredient
   where name in ("A", "B")
);