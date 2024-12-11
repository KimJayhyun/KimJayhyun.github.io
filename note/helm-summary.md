
### 주요 명령어
1. **리포지토리 추가**
   ```bash
   helm repo add <repo_name> <repo_url>
   ```
   예:
   ```bash
   helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
   ```

2. **리포지토리 목록 확인**
   ```bash
   helm repo list
   ```
   출력 예:
   ```
   NAME                   URL
   prometheus-community   https://prometheus-community.github.io/helm-charts
   ```

3. **리포지토리 업데이트**
   Helm 차트 정보를 최신 상태로 유지하려면 리포지토리를 업데이트해야 합니다.
   ```bash
   helm repo update
   ```

---

## 2. **Helm 차트 검색**
리포지토리 내에서 사용할 수 있는 차트를 검색합니다.

### 주요 명령어
1. **리포지토리에서 차트 검색**
   ```bash
   helm search repo <repo_name>
   ```
   예:
   ```bash
   helm search repo prometheus
   ```

2. **Artifact Hub에서 Helm 차트 검색**
   Helm 차트를 포함한 다양한 패키지를 Artifact Hub에서 검색할 수 있습니다.
   ```bash
   helm search hub <chart_name>
   ```
   예:
   ```bash
   helm search hub nginx
   ```

---

## 3. **Helm 차트 설치**
Kubernetes 클러스터에 차트를 설치합니다.

### 주요 명령어
1. **기본 설정으로 설치**
   ```bash
   helm install <release_name> <repo_name>/<chart_name>
   ```
   예:
   ```bash
   helm install my-prometheus prometheus-community/prometheus
   ```

2. **사용자 정의 설정 파일 사용**
   `values.yaml` 파일로 설정을 오버라이드합니다.
   ```bash
   helm install <release_name> <repo_name>/<chart_name> -f <path_to_values.yaml>
   ```
   예:
   ```bash
   helm install my-prometheus prometheus-community/prometheus -f custom-values.yaml
   ```

3. **명령줄 옵션으로 설정 변경**
   특정 설정값만 명령줄에서 바로 변경할 수 있습니다.
   ```bash
   helm install <release_name> <repo_name>/<chart_name> --set <key>=<value>
   ```
   예:
   ```bash
   helm install my-prometheus prometheus-community/prometheus --set alertmanager.enabled=false
   ```

---

## 4. **Helm 릴리스 관리**
설치된 릴리스의 상태를 확인하거나 업그레이드, 삭제합니다.

### 주요 명령어
1. **설치된 릴리스 확인**
   ```bash
   helm list -n <namespace>
   ```
   예:
   ```bash
   helm list -n monitoring
   ```

2. **릴리스 업그레이드**
   ```bash
   helm upgrade <release_name> <repo_name>/<chart_name> -f <path_to_values.yaml>
   ```
   예:
   ```bash
   helm upgrade my-prometheus prometheus-community/prometheus -f updated-values.yaml
   ```

3. **릴리스 삭제**
   ```bash
   helm uninstall <release_name> -n <namespace>
   ```
   예:
   ```bash
   helm uninstall my-prometheus -n monitoring
   ```

---

## 5. **Helm 차트 확인 및 디버깅**
차트의 구조나 기본 설정값을 확인하거나 디버깅할 수 있습니다.

### 주요 명령어
1. **차트 기본 설정값 확인**
   ```bash
   helm show values <repo_name>/<chart_name>
   ```
   예:
   ```bash
   helm show values prometheus-community/prometheus
   ```

2. **차트 디렉토리 구조 확인**
   ```bash
   helm show chart <repo_name>/<chart_name>
   ```

3. **템플릿 렌더링**
   Kubernetes 매니페스트로 템플릿을 렌더링하여 적용 전에 확인합니다.
   ```bash
   helm template <release_name> <repo_name>/<chart_name> -f <path_to_values.yaml>
   ```
   예:
   ```bash
   helm template my-prometheus prometheus-community/prometheus -f custom-values.yaml
   ```

---

## 6. **Helm 패키지 생성 및 공유**
직접 만든 Helm 차트를 패키징하거나, 리포지토리에 공유할 수 있습니다.

### 주요 명령어
1. **Helm 차트 생성**
   ```bash
   helm create <chart_name>
   ```
   예:
   ```bash
   helm create my-chart
   ```

2. **Helm 차트 패키징**
   ```bash
   helm package <chart_directory>
   ```
   예:
   ```bash
   helm package my-chart
   ```

3. **Helm 리포지토리에 업로드**
   `index.yaml`을 생성하고 이를 리포지토리에 업로드합니다.
   ```bash
   helm repo index <path_to_chart_directory>
   ```

---

### 요약 프로세스와 명령어
1. **리포지토리 설정**:
   - `helm repo add`, `helm repo update`.
2. **차트 검색**:
   - `helm search repo <repo_name>`.
3. **차트 설치**:
   - `helm install`, `helm install --set`, `helm install -f`.
4. **릴리스 관리**:
   - `helm list`, `helm upgrade`, `helm uninstall`.
5. **차트 확인 및 디버깅**:
   - `helm show values`, `helm template`.
6. **패키지 생성 및 공유**:
   - `helm create`, `helm package`.

Helm CLI는 Kubernetes 환경에서 애플리케이션 배포를 효율적으로 관리할 수 있도록 도와주는 강력한 도구입니다.