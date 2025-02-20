🛠 LVM 계층 구조
LVM(Logical Volume Manager)은 다음과 같은 계층으로 구성됩니다.

1️⃣ 물리적 볼륨 (PV, Physical Volume)

실제 물리 디스크 또는 파티션을 의미하며, LVM에서 사용하도록 초기화된 상태.
예: /dev/sda1, /dev/sdb
2️⃣ 볼륨 그룹 (VG, Volume Group)

하나 이상의 물리적 볼륨(PV) 을 묶어 하나의 큰 스토리지 풀처럼 관리.
논리 볼륨을 생성할 수 있는 공간을 제공.
예: centos_redmine
3️⃣ 논리 볼륨 (LV, Logical Volume)

볼륨 그룹(VG)에서 할당된 공간을 사용하여 생성.
OS에서 일반적인 파티션처럼 인식되어 사용 가능.
예: /dev/centos_redmine/home
4️⃣ 파일 시스템 (File System)

논리 볼륨(LV) 위에 파일 시스템을 생성하여 데이터를 저장할 수 있도록 함.
예: XFS, EXT4 등


### 📌 LVM 계층 구조와의 관계 요약

| 계층 | 예제 | 설명 |
|------|------|------|
| **물리적 볼륨 (PV)** | `/dev/sda1` | 실제 디스크 또는 디스크의 일부 |
| **볼륨 그룹 (VG)** | `centos_redmine` | 여러 PV를 묶어서 하나의 큰 공간으로 사용 |
| **논리 볼륨 (LV)** | `/dev/centos_redmine/home` | VG에서 공간을 할당받아 생성된 논리적 파티션 |
| **파일 시스템** | `XFS` | LV 위에 생성하여 데이터를 저장할 수 있도록 설정 |

---