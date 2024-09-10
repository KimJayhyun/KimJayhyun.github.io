1. nvidia container toolkit 설치
    - [Nvidia 공식 문서](https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/latest/install-guide.html)
2. Configure the container runtime by using the nvidia-ctk command:

    ```bash
    sudo nvidia-ctk runtime configure --runtime=docker
    ```

3. CDI specification file 생성

    ```bash
    sudo nvidia-ctk cdi generate --output=/etc/cdi/nvidia.yaml
    ```

4. docker daemon restart

    ```bash
    sudo systemctl restart docker
    ```


4. 실행
    - docker run command
    ```bash
    sudo docker run --rm --runtime=nvidia --gpus all ubuntu nvidia-smi
    ```

    - `docker-compose.yml`
    ```yaml
    version: '3.8'

    services:
    ubuntu-gpu:
        image: ubuntu
        runtime: nvidia
        deploy:
        resources:
            reservations:
            devices:
                - capabilities: [gpu]
        environment:
        - NVIDIA_VISIBLE_DEVICES=all
        command: nvidia-smi
    ```