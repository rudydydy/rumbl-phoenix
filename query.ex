query = Category

query = from c in query, order_by: c.name

query = from c in query, select: {c.name, c.id}

Repo.all query
