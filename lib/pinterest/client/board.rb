module Pinterest
  class Client
    module Board

      def list_boards(options={})
        get("boards", options)
      end

      def get_board(id, options={})
        get("boards/#{id}", options)
      end

      def create_board(params={})
        post('boards', params)
      end

      def update_board(params={})
        patch('boards', params)
      end

      def delete_board(id)
        delete("boards/#{id}")
      end

    end
  end
end
