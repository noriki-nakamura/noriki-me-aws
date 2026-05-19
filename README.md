# noriki-me-aws

このプロジェクトは、Terraformを使用してAWSインフラストラクチャを構築および管理するためのリポジトリです。

## プロジェクト構成

リポジトリは、以下の主要なディレクトリで構成されています。

- **`vpc/`**: ネットワーク基盤（VPC、サブネット、ルーティング、セキュリティグループ）、踏み台サーバー（Bastion）、およびAWS Directory Service (Simple AD) などのリソースを管理します。
- **`ec2/`**: EC2インスタンスに関する設定やIAMロール（SSM用など）を管理します。
- **`state-control/`**: Terraformのステートファイルを保存するためのS3バケットなどのバックエンド設定を管理します。S3のネイティブロック機能を利用しています。

## 前提条件

このプロジェクトを実行するには、以下のツールがインストールされている必要があります。

- [Terraform](https://developer.hashicorp.com/terraform/downloads) (v1.x以上推奨)
- [AWS CLI](https://docs.aws.amazon.com/ja_jp/cli/latest/userguide/getting-started-install.html)
- 適切な権限を持つAWSアカウントのクレデンシャル設定（MFA認証環境など）

## 使用方法

### 1. 環境設定ファイルの準備
環境固有の情報（AWSアカウントIDを含むS3バケット名など）はコードから分離されています。
新規構築の際は、プロジェクトのルートディレクトリに以下の2つのファイルを作成してください。

**`backend.hcl`** (Terraformバックエンド設定用)
```hcl
bucket = "terraform-state-YOUR_ACCOUNT_ID"
```

**`terraform.tfvars`** (Terraform変数用)
```hcl
state_bucket_name = "terraform-state-YOUR_ACCOUNT_ID"
```

### 2. ステート管理用リソースの構築
最初に、Terraformのステートファイルを安全に管理するためのS3バケットを作成します。
```bash
cd state-control
terraform init -backend-config="../backend.hcl"
terraform apply -var-file="../terraform.tfvars"
```

### 3. インフラストラクチャのデプロイ
ネットワーク基盤など、主要なリソースをデプロイします。
```bash
cd ../vpc
terraform init -backend-config="../backend.hcl"
terraform plan
terraform apply
```

> **注意**: `terraform.tfvars` ファイルは機密情報（パスワードやIDなど）を含む可能性があるため、Gitの管理から除外 (`.gitignore`に記載) されている場合があります。必要に応じてテンプレートから作成して配置してください。

## 構成のポイント

- **Terraformバックエンド**: S3バケットを使用したステート管理を行っています。
- **AWS Provider**: `hashicorp/aws` プロバイダー（v6.x 系）を使用しています。

## GitHub Actions (CI/CD) の設定

本リポジトリでは GitHub Actions と AWS OIDC を連携し、Pull Request 作成時に自動で `terraform plan` などが実行される仕組みを導入しています。
この機能を利用するためには、GitHub リポジトリの **Settings > Secrets and variables > Actions** に以下の値を **Repository secrets** として登録してください。

- **`AWS_ACCOUNT_ID`**: デプロイ対象の AWS アカウント ID（12桁の数字）

これらを登録することで、CI実行時に動的に `backend.hcl` と `terraform.tfvars` が生成され、AWS へのセキュアな認証が OIDC 経由で行われます。