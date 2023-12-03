select
    type_id, 
    identifier,
    "description"
    getdate() as updated_at
from airplane_type