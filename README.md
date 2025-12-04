# Guia Completo: Publicando um App Flutter na Google Play Store

## Requisitos

Antes de começar, você precisa ter:

* Flutter instalado e configurado
* Conta Google Play Console (custa uns 100 conto por ano, por aí)
* Projeto Flutter funcionando
* Certificado de assinatura (keystore) ou opção de assinatura automática pelo Google

---

## 1. Preparar o App para Produção

### Verifique o `pubspec.yaml`

* Atualize nome, versão e descrição:

```yaml
version: 1.0.0+1
```

### Ative o modo release

Execute:

```bash
flutter build apk --release
```

Ou para app bundle (recomendado):

```bash
flutter build appbundle --release
```

---

## 2. Configurar a Assinatura do Aplicativo

### Criar um keystore:

```bash
keytool -genkey -v -keystore my-key.keystore -alias upload -keyalg RSA -keysize 2048 -validity 10000
```

### Configurar o keystore no Flutter

Crie o arquivo `android/key.properties`:

```properties
storePassword=senha
keyPassword=senha
keyAlias=upload
storeFile=my-key.keystore
```

Edite `android/app/build.gradle` adicionando:

```gradle
signingConfigs {
    release {
        keyAlias keystoreProperties['keyAlias']
        keyPassword keystoreProperties['keyPassword']
        storeFile file(keystoreProperties['storeFile'])
        storePassword keystoreProperties['storePassword']
    }
}
```

---

## 3. Atualizar Detalhes do App no Android

### Nome do App

`android/app/src/main/AndroidManifest.xml`:

```xml
android:label="Meu App"
```

### ID do Pacote

Em `android/app/build.gradle`:

```gradle
applicationId "com.meuprojeto.app"
```

---

## 4. Gerar o App Bundle (Para Play Store)

```bash
flutter build appbundle --release
```

O arquivo será gerado em:

```
build/app/outputs/bundle/release/app-release.aab
```

---

## 5. Configurar o App no Google Play Console

* Criar o projeto lá

---

## 6. Preparar Ficha do App

Preencha:

* Descrição curta e longa
* Ícone (512x512)
* Imagens/screenshots
* Feature graphic
* Categoria e classificação indicativa
* Política de Privacidade

---

## 7. Subir o App Bundle

1. Vá em **Produção > Criar nova versão**
2. Faça upload do arquivo `.aab`
3. Informe notas da versão
4. Clique em **Salvar**

---

## 8. Enviar para Revisão

Após tudo marcado como concluído:

* Vá em **Produção**
* Clique em **Enviar para análise**

O Google geralmente leva entre 24h e 7 dias para aprovar.

---
