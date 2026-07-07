local HttpService = game:GetService("HttpService")

local ChatClient = {}

ChatClient.MessageReceived = Instance.new("BindableEvent")

local Socket

function ChatClient.Connect(url)
	Socket = WebSocket.connect(url)

	Socket.OnMessage:Connect(function(message)
		local data = HttpService:JSONDecode(message)

		ChatClient.MessageReceived:Fire(
			data.header,
			data.content,
			data.time
		)
	end)
end


function ChatClient.Send(header, content)
	if not Socket then
		warn("Not connected")
		return
	end

	Socket:Send(HttpService:JSONEncode({
		header = header,
		content = content,
		time = os.time()
	}))
end


return ChatClient
