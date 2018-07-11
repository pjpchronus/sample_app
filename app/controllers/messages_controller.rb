class MessagesController < ApplicationController
	def index
		# @with_user_messages = (current_user.sent_messages.where(receiver_id: params[:receiver_id])\
			# + current_user.received_messages.where(sender_id: params[:receiver_id])).sort_by(&:created_at)
		other_user = User.find_by(id: params[:receiver_id])
		if other_user.nil?
			flash[:danger] = "User doesn't exist!"
		    redirect_back(fallback_location: root_path) and return
		end
		@with_user_messages = Message.between_users(current_user, other_user)
		@message = current_user.sent_messages.build(receiver_id: params[:receiver_id])
	end

	def create
		@message = current_user.sent_messages.build(message_params)
		if @message.save
		  flash[:success] = "Message sent!"
		  redirect_back(fallback_location: users_path)
		else
			flash[:danger] = "Message sending failed!!"
		    other_user = User.find_by(id: message_params[:receiver_id])	
			@with_user_messages = Message.between_users(current_user, other_user)
			redirect_to messages_path(id: current_user.id, receiver_id: message_params[:receiver_id])
		end
	end

	def destroy
		Message.find(params[:id]).destroy
		flash[:success] = "Message deleted!"
		redirect_back(fallback_location: messages_path)		
	end

	private

    def message_params
      params.require(:message).permit(:content, :receiver_id)
    end
end