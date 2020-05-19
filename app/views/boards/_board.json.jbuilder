json.extract! board, :id, :lists, :name, :owner, :created_at, :updated_at
json.url board_url(board, format: :json)
