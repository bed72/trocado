# 💸 Trocado

Aplicativo de **finanças pessoais para casais**, desenvolvido em **Flutter**, utilizando:

- **Modugo** → Arquitetura modular
- **MobX** → Gerenciamento de estado reativo
- **Tostore** → Banco de dados local

O objetivo é permitir que cada usuário organize suas carteiras, categorias e transações, podendo futuramente compartilhar com um parceiro.

---

## 🚀 Tecnologias

- Flutter (>=3.22)
- Modugo (arquitetura modular)
- MobX + mobx_codegen
- Tostore para persistência local
- Equatable (comparação de objetos imutáveis)

---

## ⚙️ Configuração do MobX

### 1. Dependências

Adicione ao `pubspec.yaml`:

```yaml
dependencies:
  equatable: ^2.0.5

  mobx: ^2.3.0
  flutter_mobx: ^2.2.0

dev_dependencies:
  build_runner: ^2.4.8
  mobx_codegen: ^2.3.0
```

### 2. Criar um Store

```dart
import 'package:mobx/mobx.dart';
part 'counter_store.g.dart';

class CounterStore = _CounterStoreBase with _$CounterStore;

abstract class _CounterStoreBase with Store {
  @observable
  int value = 0;

  @action
  void increment() => value++;
}
```

### 3. Gerar os arquivos

Rodar para **todos os arquivos**:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Rodar em **modo watch** (atualiza automaticamente):

```bash
flutter pub run build_runner watch --delete-conflicting-outputs
```

Rodar para **um arquivo específico**:

```bash
flutter pub run build_runner build --delete-conflicting-outputs --build-filter="lib/features/wallet/stores/wallet_store.g.dart"
```

### 4. Usar no Flutter

```dart
final counter = CounterStore();

Observer(
  builder: (_) => Text('Value: ${counter.value}'),
);
```

---

## 📲 Como rodar

1. Instale as dependências:

```bash
flutter pub get
```

2. Gere os arquivos MobX:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

3. Execute o app:

```bash
flutter run
```

---

## 🔧 Script utilitário (mobx.sh)

Para não precisar lembrar os comandos longos do MobX, criamos um script Bash.

### Como usar

1. Dê permissão de execução ao script (apenas na primeira vez):

```bash
chmod +x mobx.sh
```

2. Rode o script com os comandos desejados:

- Gerar código para **todos** os arquivos:

```bash
./mobx.sh build
```

- Assistir mudanças e gerar automaticamente:

```bash
./mobx.sh watch
```

- Gerar código para um **arquivo específico**:

```bash
./mobx.sh build lib/stores/todo_store.dart
```

---

## 📜 Licença

```
Copyright (c) 2025 Gabriel Ramos
Todos os direitos reservados.

Este software é de propriedade exclusiva de **Gabriel Ramos**.
É proibida qualquer cópia, modificação, distribuição, comercialização ou uso sem autorização expressa e por escrito do proprietário.

Para solicitar autorização de uso, entre em contato: [developer.bed@gmail.com].
```
