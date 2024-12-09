Rocky Linux에서 ISO 파일을 `yum repository`로 설정하려면, ISO 파일을 로컬에 마운트하고, 이를 yum repository로 설정하는 과정을 진행해야 합니다. 아래 단계를 따라주세요:

1. **ISO 파일 마운트하기:**
   먼저, ISO 파일을 서버에 마운트해야 합니다. 예를 들어, `/mnt/rocky_iso` 디렉터리를 만들어서 ISO 파일을 마운트할 수 있습니다.

   ```bash
   mkdir /mnt/rocky_iso
   mount -o loop /path/to/your/rocky-linux.iso /mnt/rocky_iso
   ```

2. **YUM Repository 설정:**
   ISO 파일을 yum repository로 설정하려면, `/etc/yum.repos.d/` 디렉터리에 새로운 repo 파일을 만들어야 합니다. 예를 들어, `rocky.repo`라는 파일을 생성합니다.

   ```bash
   vi /etc/yum.repos.d/rocky.repo
   ```

   그리고 다음과 같은 내용을 추가합니다:

   ```ini
   [rocky-iso-AppStream]
   name=Rocky Linux $releasever - AppStream
   baseurl=file:///mnt/rocky_iso/AppStream
   enabled=1
   gpgcheck=0

   [rocky-iso-BaseOS]
   name=Rocky Linux $releasever - BaseOS
   baseurl=file:///mnt/rocky_iso/BaseOS
   enabled=1
   gpgcheck=0
   ```

   이 파일은 ISO 파일을 로컬 리포지토리로 사용하도록 설정합니다.

3. **마운트된 ISO 파일 사용 확인:**
   설정이 완료되면, `yum`을 사용해 로컬 ISO 리포지토리가 제대로 설정되었는지 확인할 수 있습니다.

   ```bash
   yum repolist
   ```

   `rocky-iso`라는 레포지토리가 리스트에 나타나면 성공적으로 설정된 것입니다.

4. **ISO 파일을 언마운트하기 (필요시):**
   만약 서버를 재부팅하거나 마운트를 해제하려면, 아래 명령어로 ISO 파일을 언마운트할 수 있습니다.

   ```bash
   umount /mnt/rocky_iso
   ```

이 과정을 통해 Rocky Linux 서버에서 ISO 파일을 yum repository로 설정할 수 있습니다.