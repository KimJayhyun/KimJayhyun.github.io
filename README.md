##  Jekyll 테마 설정 전 : `v.0.0.0`
### 테마 설정 전 환경설정 저장
- `Ruby` 설치
    - 3.3.2
    - rbenv 선택 사항
- `Bundler` 설치
    ```Shell
    $ echo "gem: --no-document" > ~/.gemrc
    $ gem install bundler
    ```

- `jekyll` 설치
    ```Shell
    $ gem install jekyll
    ```

- `Git Repository` 생성
    - `{username}/{username}.github.io`으로 생성
    
- Project 초기화
    ```Shell
    # 작업경로 : {username}.github.io
    # 
    $ jekyll new ./

    # Gem 설치 후, Update하여 재 설치
    $ bundle install
    $ bundle update
    $ bundle install

    # 정상 설치 확인
    # localhost:4000 접속
    $ bundle exec jekyll serve
    ```