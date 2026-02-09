# Branch Protection Setup

## วิธีตั้งค่าห้าม merge เข้า main โดยตรง

### ขั้นตอนการตั้งค่าใน GitHub:

1. ไปที่ Repository → **Settings**
2. ไปที่ **Branches** (ในเมนูด้านซ้าย)
3. กดปุ่ม **Add branch protection rule**
4. ตั้งค่าดังนี้:

### Branch name pattern

```
main
```

### Protection Rules ที่แนะนำ:

#### ✅ Require a pull request before merging

- เปิดใช้งานเพื่อบังคับให้ต้องสร้าง Pull Request ก่อน merge
- **Require approvals**: จำนวนคนที่ต้อง approve (แนะนำ 1 คน)
- ✅ **Dismiss stale pull request approvals when new commits are pushed**
- ✅ **Require review from Code Owners** (ถ้ามีไฟล์ CODEOWNERS)

#### ✅ Require status checks to pass before merging

- ✅ **Require branches to be up to date before merging**
- เลือก status checks ที่ต้อง pass:
    - Analyze code
    - Run tests (ถ้ามี)

#### ✅ Require conversation resolution before merging

- บังคับให้ต้อง resolve comments ทั้งหมดก่อน merge

#### ✅ Do not allow bypassing the above settings

- ไม่ให้ admin bypass rules (แนะนำสำหรับความปลอดภัย)

#### ❌ Allow force pushes (ปิดไว้)

- ห้าม force push เข้า main

#### ❌ Allow deletions (ปิดไว้)

- ห้ามลบ branch main

---

## Development Workflow

### 1. สร้าง feature branch

```bash
git checkout -b feature/your-feature-name
# หรือ
git checkout -b fix/bug-description
```

### 2. ทำงานและ commit

```bash
git add .
git commit -m "Your commit message"
git push origin feature/your-feature-name
```

### 3. สร้าง Pull Request

- ไปที่ GitHub repository
- กดปุ่ม "Compare & pull request"
- เขียน description อธิบายการเปลี่ยนแปลง
- Request review (ถ้ามี)

#### ตัวอย่าง PR

**PR Title:**

```
feat: Add image precaching for better first-load performance
```

**PR Description:**

```markdown
## 📝 Description

แก้ปัญหารูปภาพโหลดไม่ขึ้นเมื่อเปิดเว็บครั้งแรก โดยเพิ่ม image precaching

## 🔧 Changes

- เพิ่ม `_preloadImages()` ใน SplashScreen เพื่อ precache รูปภาพสำคัญ
- เพิ่ม precache ใน Gallery page สำหรับรูปใน journey-of-us
- เพิ่ม `didChangeDependencies()` ใน main.dart เพื่อ precache main logo
- เพิ่ม subfolder paths ใน pubspec.yaml (2017-2026) เพื่อให้ Flutter build รูปทั้งหมด
- ปรับ nginx cache policy แยกเป็น 3 ระดับ (HTML, JS/CSS, Images)

## ✅ Testing

- [x] Build และทดสอบ local แล้ว
- [x] ตรวจสอบว่ามีรูปภาพครบ 62 ไฟล์ใน journey-of-us
- [x] ทดสอบการโหลดหน้าเว็บครั้งแรก

## 📸 Screenshots (ถ้ามี)

[แนบภาพหน้าจอก่อน/หลังแก้ไข]

## 🔗 Related Issues

Closes #123 (ถ้ามี issue ที่เกี่ยวข้อง)

## 📋 Checklist

- [x] Code follows project style guidelines
- [x] Self-review completed
- [x] Comments added for complex logic
- [x] Documentation updated (if needed)
- [x] No new warnings generated
- [x] Tests added/updated (if applicable)
```

**ภาพตัวอย่าง PR:**

```
┌─────────────────────────────────────────────────┐
│ feat: Add image precaching for better          │
│ first-load performance                          │
├─────────────────────────────────────────────────┤
│                                                 │
│ 📝 Description                                  │
│ แก้ปัญหารูปภาพโหลดไม่ขึ้น...                   │
│                                                 │
│ 🔧 Changes                                      │
│ • เพิ่ม _preloadImages()...                     │
│ • เพิ่ม precache ใน Gallery...                 │
│                                                 │
│ ✅ Testing                                      │
│ ☑ Build และทดสอบ local แล้ว                    │
│                                                 │
├─────────────────────────────────────────────────┤
│ Reviewers: [@teammate]                          │
│ Assignees: [@yourself]                          │
│ Labels: enhancement, bug fix                    │
├─────────────────────────────────────────────────┤
│ ✓ Validate PR                                   │
│ ✓ All checks have passed                        │
└─────────────────────────────────────────────────┘
   [Merge pull request ▼] [Close pull request]
```

### 4. Review และ Merge

- รอให้ CI/CD tests ผ่าน
- รอให้มีคน approve (ถ้าตั้งค่าไว้)
- Merge เข้า main ผ่าน GitHub UI

### 5. Deploy (ด้วย Tag)

```bash
# Checkout main และ pull ล่าสุด
git checkout main
git pull origin main

# สร้าง tag version
git tag -a v1.0.0 -m "Release version 1.0.0"
git push origin v1.0.0
```

---

## 📖 ตัวอย่างการทำงานแบบเต็ม (Step-by-Step)

### Scenario: เพิ่ม feature ใหม่

```bash
# 1. อัพเดท main branch ให้เป็นเวอร์ชันล่าสุด
git checkout main
git pull origin main

# 2. สร้าง feature branch ใหม่
git checkout -b feature/add-rsvp-form

# 3. ทำงานและ commit (commit บ่อยๆ)
# ... แก้ไขไฟล์ ...
git add lib/rsvp_page.dart
git commit -m "feat: Add RSVP form UI"

# ... แก้ไขไฟล์เพิ่ม ...
git add lib/rsvp_page.dart lib/services/rsvp_service.dart
git commit -m "feat: Add RSVP submission logic"

# 4. Push branch ขึ้น GitHub
git push origin feature/add-rsvp-form

# 5. ไปที่ GitHub และสร้าง Pull Request
# - เปิด repository บน GitHub
# - จะเห็นปุ่ม "Compare & pull request" (สีเขียว)
# - กรอกข้อมูล PR ตามตัวอย่างด้านบน
# - กด "Create pull request"

# 6. รอ CI/CD checks ผ่านและรอ review
# - GitHub Actions จะรัน tests อัตโนมัติ
# - ถ้า checks fail ให้แก้แล้ว push ใหม่:
git add .
git commit -m "fix: Resolve linting issues"
git push origin feature/add-rsvp-form

# 7. หลัง PR approved และ checks ผ่าน
# - กด "Merge pull request" บน GitHub
# - เลือก merge strategy (แนะนำ "Squash and merge")
# - กด "Confirm merge"

# 8. ลบ feature branch (cleanup)
git checkout main
git pull origin main
git branch -d feature/add-rsvp-form
git push origin --delete feature/add-rsvp-form

# 9. Deploy (เมื่อพร้อม)
git tag -a v1.1.0 -m "Release v1.1.0: Add RSVP form"
git push origin v1.1.0
# GitHub Actions จะ deploy ไปยัง Fly.io อัตโนมัติ
```

### Tips สำหรับการทำ PR

1. **PR ควรมีขนาดเล็กและมุ่งเป้า** - แก้ไขเฉพาะสิ่งที่เกี่ยวข้อง
2. **Commit message ที่ชัดเจน** - ใช้ convention: `type: description`
3. **เขียน description ให้ละเอียด** - อธิบายว่าทำอะไร ทำไม และทดสอบอย่างไร
4. **ตอบ comments ทันที** - ถ้ามี review comments
5. **Keep branch updated** - ถ้า main มีการเปลี่ยนแปลง ให้ rebase:
    ```bash
    git checkout feature/your-branch
    git fetch origin
    git rebase origin/main
    git push --force-with-lease origin feature/your-branch
    ```

---

## Branch Naming Convention

- `feature/*` - สำหรับ feature ใหม่
- `fix/*` - สำหรับแก้ bug
- `hotfix/*` - สำหรับแก้ปัญหาเร่งด่วน
- `refactor/*` - สำหรับ refactor code
- `docs/*` - สำหรับแก้ไข documentation

---

## หมายเหตุ

การตั้งค่า Branch Protection จะช่วย:

- ป้องกันการ push โดยตรงเข้า main
- ให้มีการ code review ก่อน merge
- รับรองว่า tests ผ่านก่อน merge
- เก็บประวัติการเปลี่ยนแปลงที่ชัดเจน
