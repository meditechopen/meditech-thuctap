# Bài nói chuyện của Edward Snowden về cloud, open source và "nỗi sợ hãi" tại OpenStack Summit

"Chúng ta không làm việc cho chính phủ, chúng ta không làm việc cho các tiểu bang và các tập đoàn. Chúng ta nên làm việc theo tinh thần của công nghệ, đưa con người tới gần hơn với một tương lai mang lại nhiều cảm hứng hơn". 

Đó là những lời mà Snowden đã chia sẻ trong cuộc đối thoại mới đây với COO của OpenStack - Mark Collier.

Tại OpenStack Submit 2017 diễn ra vào ngày 8-11/5 tại Boston, Edward Snowden đã có cuộc nói chuyện qua vệ tinh với COO của OpenStack - Mark Collier về tầm quan trọng của mã nguồn mở, bộ công cụ của anh ấy và làm thế nào mà nỗi sợ hãi có thể trở thành giá trị chính trị phổ biến nhất. Dưới đây là toàn bộ nội dung của cuộc nói chuyện kéo dài 25 phút. Các bạn cũng có thể theo dõi lại cuộc nói chuyện tại [đây](https://www.youtube.com/watch?v=DIxvFuKY0KM)

**Cộng đồng của OpenStack hiện đã lên tới hàng ngàn người, hệ thống cloud cũng đã được xây dựng trên hơn 60 quốc gia. Vậy anh nghĩ sao về cloud computing và điều mà tôi vừa nói có ý nghĩa như thế nào theo cá nhân anh nhận định ?**

SNOWDEN: Có rất nhiều những cách khác nhau để nhìn nhận về điều này. Theo cách suy nghĩ thông thường thì câu trả lời nằm ở hai câu hỏi "Người dùng bình thường nghĩ gì về cloud?" và "Nó có ý nghĩa như thế nào đối với họ?". Hay nói các khác, cloud chính là các ứng dụng của Google, Gmail...Thứ giúp cho người dùng có thể dễ dàng có được tài liệu của mình khi dùng máy tính của một người khác.

Ở một mặt khác, chúng ta xét về những điều mà các bạn đang làm, về cơ sở hạ tầng dịch vụ (IAAS) - thứ đang dần trở thành xương sống của internet. Một trong những thứ nguy hiểm nhất, cũng là một trong những điều mà các bạn đang làm tốt nhất đó chính là giúp đỡ mọi người đưa ra những quyết định đúng đắn. Đối với hầu hết mọi người, internet là một điều kì diệu. Họ có thể coi ứng dụng Facebook là internet. Tuy nhiên chỉ thế thôi thì chưa đủ.

Chúng ta không thể khiến người dùng sử dụng OpenStack mà không có bất cứ một sự đảm bảo nào, nhất là khi họ đang trong quá trình xây dựng hệ thống thay và họ không muốn tiêu tốn quá nhiều tiền bạc và thời gian. Điều này làm dấy lên câu hỏi tại sao. Đặc biệt khi mà có rất nhiều những sự lựa chọn phi lợi nhuận khác nếu chúng ta xét tới cơ sở hạ tầng dịch vụ IAAS. Bạn có thể sử dụng EC2 của Amazon, Google’s Compute engine hay bất cứ thứ gì khác, chúng đều đang hoạt động khá ổn định.

Vấn đề ở đây đó là họ đang cơ bản mất đi tầm ảnh hưởng của mình. Bạn đưa họ tiền và đổi lại, bạn mong muốn rằng mình sẽ được cung cấp  dịch vụ. Tuy nhiên, bạn đang đưa cho họ nhiều hơn là tiền bạc: đó là dữ liệu, là việc từ bỏ quyền kiểm soát và tầm ảnh hưởng của mình. Bạn không thể thay đổi cơ sở hạ tầng của họ và cũng không thể điều chỉnh nó để phù hợp hơn với nhu cầu của mình. Đến một thời điểm nào đó, bạn có thể thay đổi nó một chút bằng việc đóng gói và vận chuyển một vài thứ xung quanh. Tuy nhiên suy cho cùng thì bạn cũng chỉ đang bỏ tiền cho một thứ cơ bản là không thuộc về mình.

Những gì mà OpenStack làm đó chính là khiến bạn mất đi nỗi sợ về việc đầu tư vào thứ mà bạn không có sức ảnh hưởng , không sở hữu và thậm chí là không thể kiểm soát.  Với OpenStack, bạn sẽ xây dựng nó theo từng layer, điều này đòi hỏi bạn phải nắm vững về kĩ thuật. Khi mà nó được phát triển theo mã nguồn mở thì chúng ta đã có thể bắt đầu hình dung về một thế giới nơi mà cơ sở hạ tầng điện toán đám mây không phải là của riêng các tổ chức mà là của chính cá nhân mỗi người - dù bạn đang sở hữu doanh nghiệp nhỏ hay lớn hay một cộng đồng các nhà khoa học, bạn vẫn có thể sở hữu nó, kiểm soát và định hình cho nó.

**Một số thành viên trong cộng đồng OpenStack muốn biết về kinh nghiệm của anh với mã nguồn mở, anh đang sở hữu những gì?**

Có lẽ một trong số những dự án nổi tiếng nhất mà tôi từng tham gia đó là khi còn hoạt động ở Cơ quan An ninh Quốc gia Hoa Kỳ (NSA) vào năm 2013. Tuy nhiên có thể mọi người sẽ không quá bận tâm vì NSA đang sử dụng Windows dù thực tế họ cũng có những máy chủ Linux. Theo những tài liệu [Vault 7](https://en.wikipedia.org/wiki/Vault_7) vừa được NSA và CIA công bố thì có vẻ họ là những người xâm phạm khá "hung hăng". 

Vault 7 là tiết lộ lớn nhất từ trước tới nay về hoạt động ngầm của CIA. Phần đầu của Vault 7 có tên Year Zero gồm hơn 8.700 tài liệu và tệp tin về mạng lưới an ninh cấp cao của Trung tâm Tình báo mạng CIA (CCI) đặt tại Langley, Virgina, Hoa Kỳ.

Nạn nhân của các công cụ này là hàng loạt công ty lớn của Hoa Kỳ và châu Âu, trong đó có những sản phẩm công nghệ như iPhone, thiết bị chạy Android của Google, Windows của Microsoft, và thậm chí TV của Samsung cũng bị biến thành công cụ nghe lén.

Tuy nhiên đó chỉ là về mặt báo chí. Vấn đề làm sao để hạn chế được những điều ấy? Gần như tất cả đều là có thể với mã nguồn mở. Đối với [TorGuards](https://torguard.net/), tất cả các nhà báo đã được yêu cầu sử dụng [Tails](https://tails.boum.org/) bởi tôi muốn hạn chế những sai lầm và họ cũng không phải là chuyên gia. 

Ngoài ra thì TOR là dự án quan trọng nhất mà tôi từng tham gia. Kể từ đó, tôi trở thành giám đốc và hiện giờ là chủ tịch của [Freedom of Press Foundation](https://freedom.press/). Công việc chính của tôi kể từ khi làm việc ở đây đó là mở rộng những nỗ lực đã được tạo ra bởi mã nguồn mở, ví dụ như dự án [SecureDrop](https://securedrop.org/).

Quay trở lại với vấn đề, nếu bạn đang sử dụng cơ sở hạ tầng của Google hoặc Amazon. Làm sao bạn có thể biết khi nào bạn bắt đầu bị theo dõi? Làm sao bạn biết hình ảnh của mình có bị tiết lộ cho những đối thủ khác hay không? Cho dù hình ảnh được lấy bởi đối thủ cạnh tranh hay FBI thì bạn cũng sẽ không có bất kì cảnh giác nào bởi nó xảy ra ở layer phía dưới, tức là nó đã bị ẩn đi. Điều tương tự cũng xảy ra với điện thoại.  Khi chúng ta bật airplane mode, khi chúng ta tắt định vị, làm sao ta có thể biết GPS hay ăng ten đã được tắt hay chưa? Vì thế chúng tôi đang phát triển phần cứng giúp mọi người có thể sao chép lại. Chúng tôi đang phát triển những kế hoạch giúp người dùng có thể nhìn thấy những đường đi của dòng điện trên các bo mạch.

**Thật tuyệt vời khi biết anh đang phát triển mã nguồn mở theo hướng rất có ý nghĩa với cộng đồng. Sau đây sẽ là một câu hỏi khác: Đâu là những ngụ ý về đạo đức cho những người đang phát triển mã nguồn mở khi mà họ không biết công việc của mình sẽ phục vụ điều gì, có thể trong trường hợp họ không muốn hoặc không đồng ý?**

Rõ ràng việc suy nghĩ vượt qua những license là thứ mà chúng ta cần học tập và rèn luyện. Chúng ta đã không nhận ra rằng việc chính phủ tham gia vào không hoàn toàn là xấu, có rất nhiều người tốt tại NSA, CIA và cả FBI.

Chúng ta không làm việc cho chính phủ, chúng ta không làm việc cho các tiểu bang và các tập đoàn. Chúng ta nên làm việc theo tinh thần của công nghệ, đưa con người tới gần hơn với một tương lai mang lại nhiều cảm hứng hơn. Tôi cố gắng nghĩ về điều này theo phạm trù của giá trị mà nó mang lại: Tất cả các hệ thống phải được thiết kế để tuân theo người dùng. Chúng không được ẩn đi hay lừa dối người dùng. Đó là một trong những vấn đề lớn nhất mà chúng ta phải đối mặt với mã nguồn đóng. Việc họ không muốn chia sẻ mã code không thực sự là vấn đề mà quan trọng hơn đó chính là  ý nghĩa đem lại từ công việc họ làm. Điều này dẫn tới một thế giới mà ta có ngày hôm nay, nơi mà mỗi con chip Intel đều có lỗ hổng bảo mật. Đó là bởi sự "giám sát" của Intel, khiến chúng ta không thể thấy và thay đổi cho chính mình.

Khi bạn nghĩ về nghĩa vụ về mặt đạo đức, điều quan trọng đó là làm sao để trao quyền cho người sử dụng và nếu điều này làm đổ vỡ cấu trúc truyền thống thì làm thế nào để bảo vệ người dùng. Bởi vì công nghệ giờ đây xuất hiện ở mọi nơi nên người dùng cần phải tuân thủ theo các giá trị giúp bảo vệ họ và phục vụ cho cộng đồng.

Tôi có thắc mắc về việc khai thác các lỗ hổng. Ngày nay vẫn có những người sẵn sàng bỏ ra tới hàng triệu đô la cho việc này. Tuy thế vẫn luôn có thị trường cho nó. Vậy kinh tế sẽ ảnh hưởng thế nào tới những người đang cố bảo vệ hạ tầng của mình.

Đây là một vấn đề rất phức tạp, chúng ta có thể dành ra cả tiếng đồng hồ để nói về điều này. Việc dùng các ngôn ngữ an toàn, tuân thủ theo các tiêu chuẩn coding, designing để hạn chế đi những điểm yếu và xác thực đầu vào. Điều này sẽ làm cho việc tấn công trở nên đắt tiền hơn tuy nhiên vẫn sẽ có người tìm kiếm nó và cả những người thực hiện nó thành công. 

Chúng ta thường nói rằng vẻ đẹp của mã nguồn mở nằm ở câu "‘many eyes make all bugs shallow,". Có nghĩa rằng nếu gặp phải một bug nào đó thì nó có thể được giải quyết dễ dàng nhờ sự giúp sức của cộng đồng. Tuy vậy vẫn có rất nhiều bugs xuất hiện như [Shellshock](https://en.wikipedia.org/wiki/Shellshock_%28software_bug%29) với sự tác động rất lớn nhưng đó cũng không phải là lập luận cho rằng ta không nên phát triển mã nguồn mở nữa. Vẻ đẹp ở đây chính là bạn sẽ được rất nhiều người để mắt và tham gia vào việc phát triển code. Chúng ta sẽ học tập và phát triển như một cộng đồng.

Khi mà rõ ràng Apple hay Google và Amazon có những lỗ hổng về bảo mật thì chúng ta không thể biết được họ đã học được những gì, cùng với đó, ta cũng không thể đánh giá được cách giải quyết của họ có phải là tốt nhất hay không. Bởi vậy, mã nguồn mở đang được đánh giá cao hơn. Chúng ta muốn có một thế giới tốt đẹp hơn thì chính chúng ta sẽ xây dựng nó.

**Nhìn về phía trước, với tất cả mọi thứ anh đã nhìn thấy và mọi thứ anh biết: Anh lạc quan hay bi quan về vấn đề này?**

Nó còn phụ thuộc vào thời gian. Về bản chất thì tôi vốn là một người khá lạc quan. Khi bạn nhìn xung quanh với sự phát triển của công nghệ thông tin ngày nay thì chúng ta đang đứng ở giao lộ, nơi những con đường cắt ngang nhau. Chúng ta bị rơi vào thế tiến thoái lưỡng nan. Đây là thời điểm nguyên tử của nghề khoa học máy tính. Ở thế kỉ trước, chúng ta đã có những nhà vật lí hạt nhân, những người từng cố gắng để làm chủ khoa học...Đó chính là internet ngày nay. Vấn đề đó là chúng ta không thể dự đoán trước những diễn biến xấu có thể xảy đến với những khám phá của chúng ta. Giờ đây chúng ta cần suy nghĩ về việc làm thế nào để hạn chế bớt điều này qua việc áp dụng những tiêu chuẩn khắt khe hơn và tránh lặp lại những sai lầm mắc phải.

Chúng ta có những nguyên tắc mã hóa rất yếu kém được áp dụng cho điện thoại di động bởi chính phủ khuyến khích điều này. Họ muốn nó đủ yếu để có thể dễ dàng phá vỡ. Dù biết điều ấy nhưng hiện tại rất khó để cập nhật công nghệ cũng như gỡ bỏ những chất liệu cũ ra khỏi sản phẩm. Chúng ta cần tìm ra cách giải quyết không chỉ cho hiện tại và còn cả tương lai của 100 năm nữa.

**Một câu hỏi cuối cùng từ phía khán giả, hơi mang tính chất chính trị một chút. Chúng ta có thể làm những gì để đảo ngược lại xu hướng về chủ nghĩa dân tộc và bảo hộ?**

Điều này khá là phức tạp. Nếu bạn nhìn vào xu hướng chính trị ngày nay, dù là cuộc bầu cử mới đây ở Mỹ, Pháp hay là luật theo dõi ([Investigatory Powers Bill](https://en.wikipedia.org/wiki/Investigatory_Powers_Act_2016)) đã được thông qua ở Anh năm ngoái hay bộ luật mà người Nga gọi là [Big Brother](http://www.newsweek.com/almost-100000-russians-call-discarding-big-brother-law-489055) thì bạn sẽ nhận ra vấn đề - nỗi sợ đang là giá trị chính trị phổ biến nhất trên thế giới.

Nhắc đến khủng bố có thể làm suy yếu đi bất cứ phe đối lập nào. Nó sẽ đẩy chúng ta vào vị trí rất dễ bị tổn thương, nơi mà hệ thống giúp kiểm tra và cân bằng mà nền văn minh phương Tây dựa vào đang bắt đầu biến mất. Tòa án cũng tỏ ra e ngại với những vùng có mâu thuẫn chính trị... Ví dụ, tất cả việc giám sát ở Mỹ được coi là hành vi phạm theo Tu chính án Thứ tư (Fourth Amendment) của Hiến pháp Mỹ và Liên đoàn Tự do Dân sự Mỹ (ACLU). Tuy nhiên toàn án vẫn tỏ ra do dự với những trường hợp như trên bởi họ không muốn được nhìn nhận là chỉ áp dụng bộ luật một cách máy móc, họ cũng là con người mà con người thì ai cũng có nỗi sợ hãi riêng.

Điều này tạo ra một thế giới nơi có những mối liên kết hết sức yếu ớt trong việc bảo vệ quyền con người. Nó cũng đặt chúng ta vào nơi mà các cơ chế truyền thống của việc thực thi quyền con người bắt đầu thất bại. Điều tuyệt vời đó là trong khi các quy trình cũ đang thất bại thì chúng ta cũng nhìn thấy thoáng qua cách mà công nghệ có thể bảo vệ quyền con người vượt ra ngoài biên giới. 

Sẽ ra sao nếu chúng ta phát triển giao thức và hệ thống ẩn khỏi tầm nhìn của chúng ta hằng ngày, ở trong túi chẳng hạn. Ngay cả khi người dùng không sử dụng internet thì cuộc giao tiếp vẫn sẽ được truyền qua internet, nó sẽ dựa vào vải, mắt lưới... Bạn sẽ có thể áp dụng nó cho cơ sở hạ tầng của bệnh viện giúp đẩy hồ sơ của họ lên mạng, một người phụ nữ 90 tuổi cũng có thể dựa vào cơ chế này dù không có điện thoại.

Bằng cách này, chúng ta không chỉ tạo ra một thế giới tốt đẹp hơn mà đó còn là một thế giới tự do hơn và nó có thể xảy ra ở bất cứ vị trí nào trên trái đất nhanh như cái cách mà ta đang phát triển công nghệ.

**Link bài viết**:

http://superuser.openstack.org/articles/snowden-interview-openstack-summit/