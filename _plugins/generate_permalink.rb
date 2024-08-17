Jekyll::Hooks.register :posts, :post_init do |post|
    if post.data['permalink'].nil?
      # 파일 이름에서 확장자를 제거하고, '-'로 나누기
      filename = File.basename(post.path, File.extname(post.path))
      parts = filename.split('-')
  
      # 년, 월, 일을 제외하고 나머지 부분만 사용
      custom_path = parts[3..-1].join('/')
  
      # 'baekjoon/1003' 형태의 permalink 설정
      post.data['permalink'] = "/posts/#{custom_path}"
    end
  end
  