# Flutter Inventory App

A Flutter inventory management app integrated with **Firebase Firestore**, featuring **CRUD operations**, **real-time updates**, and **dynamic search and filter** functionality.

---

## Features

- **Add, Edit, Delete Items**: Full CRUD functionality for inventory items.
- **Real-Time Updates**: Changes in Firestore reflect instantly in the UI.
- **Search by Name**: Quickly find items using a real-time search bar.
- **Filter by Amount**: Filter items based on minimum and maximum amounts.
- **Combined Search & Filter**: Search and filter results together for precise queries.
- **Validation & UX States**: Prevents invalid inputs and shows loading/empty states.

---

## Search Functionality

- **Purpose:** Find items by name in real time.
- **How it works:**
  - Users type in the **Search by name** field.
  - The app queries Firestore for items whose names match the input.
  - The list updates automatically without manual refresh.
- **Implementation Notes:**
  - Case-insensitive search is supported via a `name_lower` field in Firestore.
  - Uses Firestore range queries (`isGreaterThanOrEqualTo` and `isLessThanOrEqualTo`) for efficiency.

---

## Filter Functionality

- **Purpose:** Narrow down items by quantity.
- **How it works:**
  - Users enter `Min Amount` and `Max Amount`.
  - Firestore returns items whose `amount` is within the specified range.
  - Results update instantly in the UI using the same real-time stream.
- **Implementation Notes:**
  - Handles empty or invalid input safely.
  - Works in combination with the search feature to refine results.

---

## Usage

1. Open the app.
2. Add items using the **+** button.
3. Edit or delete items using the action buttons on each item.
4. Type a keyword in the **Search by name** field to filter by name.
5. Enter numeric values in **Min Amount** and **Max Amount** to filter by quantity.
6. The list updates dynamically based on your inputs.

---

## Architecture

- **`Item` model**: Represents inventory items.
- **`DatabaseHelper` service**: Handles all Firestore interactions (CRUD, search, filter).
- **UI (`HomePage`)**: Displays items, search/filter inputs, and dialogs for add/edit.

---

## Future Improvements

- Debounced search input to reduce unnecessary queries.
- Pagination for large datasets.
- Soft delete with undo functionality.
- Modular widgets for forms and dialogs.

---

## Dependencies

- `flutter`
- `firebase_core`
- `cloud_firestore`
- `flutter/material.dart`

---

## License

MIT License