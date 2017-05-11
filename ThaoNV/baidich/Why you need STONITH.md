# Tại sao cần STONITH?

Có một sai lầm rất thường gặp ở các hệ thống HA Cluster, Linux-HA hay RedHat Cluster Suite,... đó là chúng không cần node fencing dù cho có rất nhiều cảnh báo ở các file logs.

### Node fencing là gì?

Fencing là một kĩ thuật cho phép các node trong một hệ thống cluster biết được các node bị "chết" đã thực sự biến mất hay chưa. Hay nói cách khác, STONITH ("Shoot the other node in the head") sẽ có nhiệm vụ cách ly node khi một node nào đó bị lỗi. Kĩ thuật này còn cho phép cluster đợi xác nhận trước khi chính thức thu hồi tài nguyên.

Có phải bạn đang tự hỏi rằng nếu node đó đã thực sự bị lỗi và bị loại khỏi hệ thống, thì tại sao lại cần fencing?

Câu trả lời nằm ở 2 cụm từ `sự xuất hiện` (appearances) và `thực tế` (reality). Khi không thể liên lạc được với 1 node nào đó, cả hệ thống cho rằng node ấy đã biến mất. Tuy nhiên thực tế lại không chỉ có vậy, nó vẫn có thể tồn tại ở đâu đó, ẩn dưới các rules của tường lửa, để rồi bạn sẽ tự hỏi tại sao dữ liệu chia sẻ giữa các node của mình lại bị lỗi.

Tóm lại, node fencing/isolation/STONITH sẽ đảm bảo tính toàn vẹn của dữ liệu trong hệ thống cluster khi có bất kì node nào đó bị hỏng.

(Peacemaker cũng sử dụng cơ chế này, nếu Peacemaker yêu cầu một node dừng dịch vụ nhưng quá trình này bị lỗi thì về bản chất dịch vụ ấy sẽ vẫn bị mắc kẹt trên node đó. Do đó, tiến trình mặc định sẽ dừng tất cả các tài nguyên, di chuyển chúng tới một node khác và cách ly node bị lỗi. Điều này sẽ giúp ngăn chặn những lỗi nhỏ trở thành những vấn đề lớn hơn.)

Tất cả những điều trên nghe có vẻ thiên quá nhiều về kĩ thuật. Hãy cùng nghe một câu chuyện để có cái nhìn rõ hơn nhé.

Ngày xửa ngày xưa, có một nhóm gồm 3 người bạn rất thân đang ngồi ăn uống và trò chuyện bên bếp lửa.

Vào thời điểm ấy, thế giới bị zombie tấn công, dịch bệnh ở khắp mọi nơi. Những người bị lây nhiễm sẽ bị vi khuẩn ăn mất não và trở thành zombie.  3 người này không tin tưởng bất cứ ai ngoài bạn của họ. Họ luôn để mắt và quan tâm lẫn nhau.

Khi cuộc nói chuyện đang diễn ra bình thường thì đột nhiên 1 trong số họ im lặng, nếu là bạn, bạn sẽ xử lí thế nào?

1. Bạn tôi không thể nhiễm bệnh, đơn giản là anh ấy đã chết và bạn bỏ qua điều này. Tuy nhiên anh bạn ấy đột ngột tỉnh dậy, lây nhiễm dịch bệnh và vi khuẩn bắt đầu ăn não của bạn. Anh bạn kia đồng thời cũng cho những người bạn mới của anh ấy biết địa điểm và bạn cùng với người bạn còn lại của mình sẽ bị một hội zombie tấn công.
2. Bạn dùng súng để bắn người bạn của mình, mọi thứ có vẻ đã ổn nhưng rồi anh bạn ấy đột ngột tỉnh dậy và lây nhiễm dịch bệnh cho bạn.
3. Bạn tiến tới, nhẹ nhàng yêu cầu bạn của mình tự tử để đảm bảo an toàn. Nhưng anh ấy đột ngột tỉnh lại và kết quả như nào bạn biết rồi đấy.
4. Bạn đưa ra một đoạn mã rồi 1 quả bom nhỏ rơi vào đầu anh bạn của bạn, thổi bay não anh ta ra ngoài và bạn an toàn. 
5. Bạn dùng súng để bắn vào đầu người bạn của mình, đảm bảo vi khuẩn không thể tiếp cận và bạn an toàn.

Theo thứ tự, các phương án trên áp dụng vào HA Cluster sẽ lần lượt là:

1. Tôi không cần STONITH hoặc tôi đã hủy bỏ nó.
2. Tôi chỉ sử dụng kĩ thuật ấy để thử nghiệm
3. Tôi sử dụng cơ chế ssh-based
4. Phương pháp được khuyến khích, chiến thuật "thuốc độc" với sự hỗ trợ của phần cứng (ví dụ như external/sdb trong môi trường Peacemaker). 
5. Yêu cầu switch, bảng điều khiển, ... tắt nguồn điện và khởi động lại hệ thống.

Nói cách khác điều này giống như việc người bạn của bạn, bất chấp mọi nỗ lực, vẫn không thể ngăn cản việc anh ấy bị lây nhiễm và rồi anh ấy cầu xin bạn hãy giết anh ấy trước khi nhưng người khác bị lây nhiễm.



**Link tham khảo:**

http://advogato.org/person/lmb/diary/105.html

